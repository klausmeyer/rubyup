class UpdateJob < ApplicationJob
  queue_as :default

  def perform(job)
    log "[#{__method__}]"
    log job.inspect

    self.job = job

    # docker_pull_image
    docker_create_container
    docker_exec_commands
    docker_remove_container

    job.update!(state: 'completed')
  rescue RuntimeError
    job.update!(state: 'failed')
  end

  private

  attr_accessor :job, :container

  def log(string)
    puts "[+] #{self.class.name} | #{provider_job_id} | #{string}"
  end

  def docker_pull_image
    log "[#{__method__}]"
    Docker::Image.create('fromImage' => DOCKER_IMAGE)
  end

  def docker_create_container
    log "[#{__method__}]"
    self.container = Docker::Container.create(
      'Image'      => "rubyup:ruby-#{job.config[:version_to]}",
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

      sudo chmod 600 .ssh/id_rsa
      sudo chown -R rubyup.rubyup .ssh

      ssh-keygen -F #{job.repository.server} || ssh-keyscan #{job.repository.server} >> /home/rubyup/.ssh/known_hosts

      git clone #{job.repository.url} workdir

      cd workdir

      git checkout -b #{branch}

      sed -i.bak "s/#{job.config[:version_from]}/#{job.config[:version_to]}/" .ruby-version || true
      sed -i.bak "s/#{job.config[:version_from]}/#{job.config[:version_to]}/" .travis.yml   || true
      sed -i.bak "s/#{job.config[:version_from]}/#{job.config[:version_to]}/" Gemfile       || true
      sed -i.bak "s/#{job.config[:version_from]}/#{job.config[:version_to]}/" Dockerfile    || true

      rm *.bak || true; rm .*.bak || true

      cd ..
      cd workdir

      bundle update nokogiri || true
      bundle install

      git config --global user.email "#{job.repository.identity.name}"
      git config --global user.name "#{job.repository.identity.email}"

      git commit -am "#{message}"
      git push origin #{branch}
    SCRIPT

    container.store_file '/home/rubyup/.ssh/id_rsa', job.repository.identity.private_key
    container.store_file '/home/rubyup/script.sh', script

    docker_exec_command 'sudo chown rubyup.rubyup /home/rubyup/script.sh; chmod +x /home/rubyup/script.sh'
    docker_exec_command '/home/rubyup/script.sh'
  end

  def docker_exec_command(command, options = {})
    log "[#{__method__}] - #{command}"
    stdout, stderr, status = container.exec(['bash', '-l', '-c', command], options)
    log "STATUS: #{status}"
    log "STDOUT: #{stdout.join}"
    log "STDERR: #{stderr.join}"
    raise RuntimeError if status != 0
  end

  def docker_remove_container
    log "[#{__method__}]"
    container.delete(force: true)
  end

  def message
    job.config[:message] % job.config.symbolize_keys
  end

  def branch
    "rubyup/update/ruby-#{job.config[:version_to]}"
  end
end
