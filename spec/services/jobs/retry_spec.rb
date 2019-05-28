require 'rails_helper'

RSpec.describe Jobs::Retry do
  let(:job) { FactoryBot.create :job, state: state }

  let(:instance) { described_class.new(job: job) }

  describe '#call' do
    before do
      ActiveJob::Base.queue_adapter = :test
    end

    context 'with a already retried job' do
      let(:state) { 'rescheduled' }

      it 'raises an error' do
        expect { instance.call }.to raise_error Jobs::Retry::InvalidStateError
      end
    end

    context 'with a faild job' do
      let(:state) { 'failed' }

      it 'resets the state attribute' do
        instance.call

        expect(job.reload.state).to eq 'rescheduled'
      end

      it 'schedules a background execution for the job' do
        expect { instance.call }.to have_enqueued_job(UpdateJob).with(job)
      end
    end
  end
end
