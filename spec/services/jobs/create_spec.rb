require 'rails_helper'

RSpec.describe Jobs::Create do
  let(:identity)  { FactoryBot.create :identity}
  let(:blueprint) { FactoryBot.build :job, repository: nil, identity: identity }

  let(:repo1) { FactoryBot.create :repository }
  let(:repo2) { FactoryBot.create :repository }

  let(:instance) { described_class.new(blueprint: blueprint, repositories: [repo1.id, repo2.id])}

  describe '#call' do
    it 'creates one job per repository based on the given blueprint job' do
      expect { instance.call }.to change(Job, :count).by(2)

      job = Job.first
      expect(job.repository).to eq repo1
      expect(job.identity).to   eq identity

      job = Job.second
      expect(job.repository).to eq repo2
      expect(job.identity).to   eq identity
    end

    it 'schedules a background execution for each created job' do
      ActiveJob::Base.queue_adapter = :test

      expect { instance.call }.to have_enqueued_job(UpdateJob).twice
    end
  end
end
