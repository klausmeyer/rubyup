require 'rails_helper'

RSpec.describe Version do
  let(:instance) { FactoryBot.create :version }

  describe '.docker_registry' do
    it 'returns the expected value' do
      expect(described_class.docker_registry).to eq '127.0.0.1:5000'
    end
  end

  describe '.docker_baseimage' do
    it 'returns the expected value' do
      expect(described_class.docker_baseimage).to eq '127.0.0.1:5000/rubyup/worker:base'
    end
  end

  describe '#docker_image' do
    it 'returns the expected value' do
      expect(instance.docker_image).to eq '127.0.0.1:5000/rubyup/worker:ruby-2.6.3'
    end
  end

  describe '#docker_repo' do
    it 'returns the expected value' do
      expect(instance.docker_repo).to eq '127.0.0.1:5000/rubyup/worker'
    end
  end

  describe '#docker_tag' do
    it 'returns the expected value' do
      expect(instance.docker_tag).to eq 'ruby-2.6.3'
    end
  end
end
