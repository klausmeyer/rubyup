class UpdateJob < ApplicationJob
  queue_as :default

  def perform(job)
    self.job = job
    self.log = []

    log_message "[#{__method__}]"

    docker_create_container
    docker_exec_commands
    docker_remove_container
    github_create_pull_request

    complete_job(state: 'completed')
  rescue => e
    log_message "Error: #{e}\n#{e.backtrace.join($INPUT_RECORD_SEPARATOR)}"
    complete_job(state: 'failed')
  end

  private

  attr_accessor :job, :container, :log

  def complete_job(state:)
    job.state = state
    job.logs << log.join($INPUT_RECORD_SEPARATOR)
    job.save!
  end

  def log_message(string)
    msg = "[+] #{self.class.name} | #{provider_job_id} | #{string}"
    log << msg
    puts msg unless Rails.env.test?
  end

  def docker_create_container
    log_message "[#{__method__}]"
    self.container = Docker::Container.create(
      'Image'      => job.version_to.docker_image,
      'Cmd'        => ['/bin/sh', '-c', 'while true; do sleep 30; done;'],
      'WorkingDir' => '/home/rubyup'
    )
    container.start
  end

  def docker_exec_commands
    script = <<~SCRIPT
      #!/bin/bash

      set -e
      set +x

      git clone -b #{job.repository.branch} #{clone_url} workdir

      cd workdir

      git checkout -b #{working_branch}

      grep -q #{job.version_to} .ruby-version && exit 1

      sed -i.bak "s/#{job.version_from}/#{job.version_to}/" .ruby-version || true
      sed -i.bak "s/#{job.version_from}/#{job.version_to}/" .travis.yml   || true
      sed -i.bak "s/#{job.version_from}/#{job.version_to}/" Gemfile       || true
      sed -i.bak "s/#{job.version_from}/#{job.version_to}/" Dockerfile    || true

      rm *.bak || true; rm .*.bak || true

      cd ..
      cd workdir

      test -f Gemfile.lock && gem install bundler -v $(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -n1 | tr -d '[:space:]')
      bundle update nokogiri || true
      bundle install

      git config --global user.email "#{job.identity.email}"
      git config --global user.name "#{job.identity.name}"

      git commit -am "#{job.config['message']}"
      git push origin #{working_branch}
    SCRIPT

    container.store_file '/home/rubyup/script.sh', script

    docker_exec_command 'sudo chown rubyup.rubyup /home/rubyup/script.sh; chmod +x /home/rubyup/script.sh'
    docker_exec_command '/home/rubyup/script.sh'
  end

  def docker_exec_command(command, options = {})
    log_message "[#{__method__}] - #{command}"
    stdout, stderr, status = container.exec(['bash', '-l', '-c', command], options)
    log_message "STATUS: #{status}"
    log_message "STDOUT: #{stdout.join}"
    log_message "STDERR: #{stderr.join}"
    raise RuntimeError if status != 0
  end

  def docker_remove_container
    log_message "[#{__method__}]"
    container.delete(force: true)
  end

  def github_create_pull_request
    client = Octokit::Client.new(access_token: job.identity.github_api_key)
    client.api_endpoint = "https://#{job.repository.server}/api/v3/" if job.repository.server != 'github.com'
    client.create_pull_request job.repository.path, job.repository.branch, working_branch, job.config['message'], job.config['details']
  end

  def clone_url
    "https://#{job.identity.github_api_key}:x-oauth-basic@#{job.repository.server}/#{job.repository.path}"
  end

  def working_branch
    "rubyup/update/ruby-#{job.version_to}"
  end
end
