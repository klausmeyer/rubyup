class Job < ApplicationRecord
  belongs_to :repository

  serialize :config

  validates :repository, presence: true
  validates :name,       presence: true
  validates :config,     presence: true
  validates :state, inclusion: { in: %w(created completed failed) }

  after_initialize :set_defaults

  scope :newest_first, -> { order(id: :desc) }

  private

  def set_defaults
    self.name   ||= Template.name
    self.config ||= Template.config
    self.state  ||= 'created'
  end
end
