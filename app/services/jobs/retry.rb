module Jobs
  class Retry
    InvalidStateError = Class.new(RuntimeError)

    def initialize(job:)
      self.job = job
    end

    def call
      job.reload
      raise InvalidStateError, "Can not retry job with state #{job.state}" unless job.state == 'failed'

      job.update! state: 'rescheduled'
      UpdateJob.perform_later(job)
    end

    private

    attr_accessor :job
  end
end
