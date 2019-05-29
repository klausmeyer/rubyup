class BuildVersionImage < ApplicationJob
  queue_as :default

  def perform(version)
    self.version = version

    Docker.options[:read_timeout] = 15.minutes

    docker_build_image
    docker_tag_image
    docker_push_image

    version.update!(state: 'available')
  rescue => e
    log_message "Error: #{e}\n#{e.backtrace.join($INPUT_RECORD_SEPARATOR)}"
    version.update!(state: 'failed')
  end

  private

  attr_accessor :version, :image

  def docker_build_image
    log_message "[#{__method__}]"
    self.image = Docker::Image.build(dockerfile)
  end

  def docker_tag_image
    log_message "[#{__method__}]"
    image.tag(
      'repo' => version.docker_repo,
      'tag'  => version.docker_tag,
      force: true
    )
  end

  def docker_push_image
    log_message "[#{__method__}]"
    image.push
  end

  def dockerfile
    <<~BUILD
      FROM #{Version.docker_baseimage}
      RUN bash -l -c "rvm install #{version.string}"
    BUILD
  end

  def log_message(string)
    msg = "[+] #{self.class.name} | #{provider_job_id} | #{string}"
    puts msg unless Rails.env.test?
  end
end
