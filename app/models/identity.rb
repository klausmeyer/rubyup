class Identity < ApplicationRecord
  validates :name,           presence: true
  validates :email,          presence: true
  validates :github_api_key, presence: true
  validates :private_key,    presence: true

  has_many :repositories

  def to_s
    "#{name} <#{email}> (##{id})"
  end
end
