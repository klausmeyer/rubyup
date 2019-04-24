class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find params[:id]
    @jobs       = @repository.jobs.newest_first
  end
end
