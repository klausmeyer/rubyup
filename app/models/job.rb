class Job < ApplicationRecord
  belongs_to :repository

  validates :repository, presence: true
  validates :name,       presence: true
  validates :config,     presence: true
  validates :state, inclusion: { in: %w(created completed failed) }

  validate :config_is_valid_yaml

  after_initialize :set_defaults

  scope :newest_first, -> { order(id: :desc) }

  private

  def set_defaults
    self.name   ||= Template.name
    self.config ||= Template.config.to_yaml
    self.state  ||= 'created'
  end

  def config_is_valid_yaml
    YAML.parse(config)
  rescue Psych::SyntaxError
    errors.add(:config, :invalid)
  end
end
