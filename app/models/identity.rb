class Identity < ApplicationRecord
  validates :name,           presence: true
  validates :email,          presence: true, uniqueness: true
  validates :github_api_key, presence: true

  has_many :jobs

  def to_s
    "#{name} <#{email}> (##{id})"
  end
end
