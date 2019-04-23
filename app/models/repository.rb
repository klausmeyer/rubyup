class Repository < ApplicationRecord
  validates :name, presence: true
  validates :url,  presence: true

  has_many :jobs

  def job
    jobs.last
  end
end
