class UpdateJob < ApplicationJob
  queue_as :default

  def perform(job)
    log "[#{__method__}]"
    log job.inspect

    docker_pull_image
    docker_create_container
    docker_exec_command ['whoami']
    docker_remove_container

    job.update!(state: 'completed')
  end

  private

  DOCKER_IMAGE = 'ruby:2.6.3-alpine'.freeze

  attr_accessor :container

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
      'Image' => DOCKER_IMAGE,
      'Cmd'   => ['/bin/sh', '-c', 'while true; do sleep 30; done;']
    )
    container.start
  end

  def docker_exec_command(command)
    log "[#{__method__}]"
    stdout, stderr, status = container.exec(command)
    log "STATUS: #{status}"
    log "STDOUT: #{stdout}"
    log "STDERR: #{stderr}"
  end

  def docker_remove_container
    log "[#{__method__}]"
    container.delete(force: true)
  end
end
