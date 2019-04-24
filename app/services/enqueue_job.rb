class EnqueueJob
  def initialize(job)
    self.job = job
  end

  def call

  end

  private

  attr_reader :job
end
