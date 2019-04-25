class UpdateJob < ApplicationJob
  queue_as :default

  def perform(job)
    puts job.inspect
  end
end
