class Identity < ApplicationRecord
  validates :name,           presence: true
  validates :email,          presence: true, uniqueness: true
  validates :github_api_key, presence: true
  validates :private_key,    presence: true

  has_many :jobs

  def to_s
    "#{name} <#{email}> (##{id})"
  end

  def private_key_signature
    SSHKey.new(private_key).md5_fingerprint
  rescue
    'Could not generate signature'
  end
end
