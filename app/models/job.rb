class Job < ApplicationRecord
  belongs_to :repository
  belongs_to :identity

  belongs_to :version_from, class_name: 'Version'
  belongs_to :version_to,   class_name: 'Version'

  serialize :logs, Array

  validates :repository, presence: true
  validates :name,       presence: true
  validates :config,     presence: true
  validates :state, inclusion: { in: %w(created rescheduled completed failed) }

  after_initialize :set_defaults

  scope :newest_first, -> { order(id: :desc) }

  private

  def set_defaults
    self.name         ||= Template.name
    self.config       ||= Template.config
    self.version_from ||= Version.for_select.second_to_last
    self.version_to   ||= Version.for_select.last
    self.identity     ||= Identity.first
    self.state        ||= 'created'
  end
end
