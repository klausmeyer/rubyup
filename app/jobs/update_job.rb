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
      'Image'      => "rubyup:ruby-#{job.config[:version_from]}",
      'Cmd'        => ['/bin/sh', '-c', 'while true; do sleep 30; done;'],
      'WorkingDir' => '/home/rubyup'
    )
    container.start
  end

  def docker_exec_commands
    docker_exec_command 'mkdir /home/rubyup/.ssh'
    docker_exec_command 'chmod 700 /home/rubyup/.ssh'

    container.store_file '/home/rubyup/.ssh/id_rsa', job.repository.key

    docker_exec_command 'chown rubyup.rubyup /home/rubyup/.ssh/id_rsa', user: 'root'
    docker_exec_command 'chmod 600 /home/rubyup/.ssh/id_rsa', user: 'root'

    docker_exec_command 'ssh-keygen -F github.com || ssh-keyscan github.com >> /home/rubyup/.ssh/known_hosts'

    docker_exec_command "git clone #{job.repository.url}"
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
end
