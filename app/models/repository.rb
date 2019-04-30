class Repository < ApplicationRecord
  validates :name, presence: true
  validates :url,  presence: true

  belongs_to :identity

  has_many :jobs

  def job
    jobs.last
  end

  def server
    url.match(URL_REGEX)[:server]
  end

  def path
    url.match(URL_REGEX)[:path]
  end

  private

  URL_REGEX = /@(?<server>.[^:]+):(?<path>.+).git$/
end
