class Repository < ApplicationRecord
  URL_REGEX = /\A(?<user>.+)@(?<server>.[^:]+):(?<path>.+).git\z/

  validates :name, presence: true
  validates :url,  presence: true, format: { with: URL_REGEX }

  has_many :jobs, dependent: :destroy

  def job
    jobs.last
  end

  def server
    url.match(URL_REGEX)[:server]
  end

  def path
    url.match(URL_REGEX)[:path]
  end
end
