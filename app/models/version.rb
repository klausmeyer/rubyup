class Version < ApplicationRecord
  validates :string, presence: true, uniqueness: true
  validates :link,   presence: true
  validates :state, inclusion: { in: %w(created available failed) }

  scope :for_select, -> { where(state: 'available').order(:string) }

  after_initialize :set_defaults

  class << self
    def docker_registry
      '127.0.0.1:5000'
    end

    def docker_baseimage
      "#{docker_registry}/rubyup/worker:base"
    end
  end

  def to_s
    string
  end

  def docker_image
    "#{docker_repo}:#{docker_tag}"
  end

  def docker_repo
    "#{self.class.docker_registry}/rubyup/worker"
  end

  def docker_tag
    "ruby-#{string}"
  end

  private

  def set_defaults
    self.state ||= 'created'
  end
end
