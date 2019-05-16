class Job < ApplicationRecord
  belongs_to :repository
  belongs_to :identity

  serialize :config
  serialize :logs, Array

  validates :repository, presence: true
  validates :name,       presence: true
  validates :config,     presence: true
  validates :state, inclusion: { in: %w(created completed failed) }

  after_initialize :set_defaults

  scope :newest_first, -> { order(id: :desc) }

  private

  def set_defaults
    self.name     ||= Template.name
    self.config   ||= Template.config
    self.identity ||= Identity.first
    self.state    ||= 'created'
  end
end
