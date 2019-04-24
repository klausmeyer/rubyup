class Job < ApplicationRecord
  serialize :config, JSON

  belongs_to :repository

  validates :repository, presence: true
  validates :config,     presence: true
  validates :state, inclusion: { in: %w(created completed failed) }

  after_initialize :set_defaults

  scope :newest_first, -> { order(id: :desc) }

  private

  def set_defaults
    self.state ||= 'created'
  end
end
