class Repository < ApplicationRecord
  validates :name, presence: true
  validates :url,  presence: true

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

  private

  URL_REGEX = /@(?<server>.[^:]+):(?<path>.+).git$/
end
