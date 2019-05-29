require 'rails_helper'

RSpec.describe BuildVersionImage do
  let(:instance) { described_class.new }

  let(:version) { FactoryBot.create :version_new }

  let(:image_double) do
    instance_double(
      'Docker::Image',
      tag:  nil,
      push: nil
    )
  end

  before do
    allow(Docker::Image).to receive(:build).and_return(image_double)
  end

  describe '#perform' do
    before do
      instance.perform(version)
    end

    it 'uses the correct base image' do
      expect(Docker::Image).to have_received(:build).with(%r{FROM 127.0.0.1:5000/rubyup/worker:base})
    end

    it 'installs the desired ruby version in the image' do
      expect(Docker::Image).to have_received(:build).with(/rvm install 2.6.3/)
    end

    it 'tags the image with the correct name' do
      expect(image_double).to have_received(:tag).with(
        'repo' => '127.0.0.1:5000/rubyup/worker',
        'tag'  => 'ruby-2.6.3',
        force: true
      )
    end

    it 'pushes the image' do
      expect(image_double).to have_received(:push)
    end

    it 'sets the version state to available' do
      expect(version.reload.state).to eq 'available'
    end
  end
end
