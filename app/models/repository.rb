class Repository < ApplicationRecord
  validates :name, presence: true
  validates :url,  presence: true
  validates :key,  presence: true

  has_many :jobs

  def job
    jobs.last
  end

  def server
    url.match(/@(?<server>.[^:]+):/)[:server]
  end
end
