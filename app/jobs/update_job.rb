class UpdateJob < ApplicationJob
  queue_as :default

  def perform(job)
    log "[#{__method__}]"
    log job.inspect

    self.job = job

    # docker_pull_image
    docker_create_container
    docker_exec_command 'rvm info'
    docker_remove_container

    job.update!(state: 'completed')
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
      'Image' => "rubyup:ruby-#{job.config[:version_from]}",
      'Cmd'   => ['/bin/sh', '-c', 'while true; do sleep 30; done;']
    )
    container.start
  end

  def docker_exec_command(command)
    log "[#{__method__}]"
    stdout, stderr, status = container.exec(['bash', '-l', '-c', command])
    log "STATUS: #{status}"
    log "STDOUT: #{stdout.join}"
    log "STDERR: #{stderr.join}"
  end

  def docker_remove_container
    log "[#{__method__}]"
    container.delete(force: true)
  end
end
