class Job < ApplicationRecord
  serialize :config, JSON

  belongs_to :repository

  validates :repository, presence: true
  validates :config,     presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.state ||= 'created'
  end
end
