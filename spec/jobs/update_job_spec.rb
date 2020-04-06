require 'rails_helper'

RSpec.describe UpdateJob do
  let(:instance) { described_class.new }

  let(:job) { FactoryBot.create :job }

  describe '#perform' do
    let(:container_double) do
      instance_double(
        'Docker::Container',
        start:      nil,
        store_file: nil,
        exec:       [exec_stdout, exec_stderr, exec_status],
        delete:     nil
      )
    end

    let(:exec_stdout) { [] }
    let(:exec_stderr) { [] }
    let(:exec_status) { 0 }

    before do
      allow(Docker::Container).to receive(:create).and_return(container_double)
    end

    let!(:req_github_api) do
      stub_request(:post, "https://github.example.com/api/v3/repos/#{job.repository.path}/pulls").to_return(status: 200)
    end

    it 'creates a new docker container' do
      instance.perform(job)

      expect(Docker::Container).to have_received(:create).with(
        'Cmd'        => ['/bin/sh', '-c', 'while true; do sleep 30; done;'],
        'Image'      => '127.0.0.1:5000/rubyup/worker:ruby-2.6.3',
        'WorkingDir' => '/home/rubyup'
      )
      expect(container_double).to have_received(:start)
    end

    it 'uploads files and executes commands' do
      instance.perform(job)

      expect(container_double).to have_received(:store_file).with '/home/rubyup/script.sh',
        a_string_including('#!/bin/bash')

      expect(container_double).to have_received(:exec).with([
        'bash', '-l', '-c',
        'sudo chown rubyup.rubyup /home/rubyup/script.sh; chmod +x /home/rubyup/script.sh'
      ], {})

      expect(container_double).to have_received(:exec).with([
        'bash', '-l', '-c',
        '/home/rubyup/script.sh'
      ], {})
    end

    it 'uses a https url with token to clone the repo' do
      instance.perform(job)

      expect(container_double).to have_received(:store_file).with '/home/rubyup/script.sh',
        a_string_including('git clone -b master https://github-api-key:x-oauth-basic@github.example.com')
    end

    it 'creates a github pull request' do
      instance.perform(job)

      expect(req_github_api.with do |req|
        expect(req.headers['Authorization']).to eq 'token github-api-key'
        expect(req.body).to be_json_eql({
          base:  job.repository.branch,
          body:  ':link: https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/',
          head:  'rubyup/update/ruby-2.6.3',
          title: 'Update Ruby to 2.6.3'
        }.to_json)
      end).to have_been_made
    end

    it 'marks the job as completed' do
      instance.perform(job)

      expect(job.reload.state).to eq 'completed'
    end
  end
end
