class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find params[:id]
    @jobs       = @repository.jobs.newest_first
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(repo_params)

    if @repository.save
      redirect_to repositories_path
    else
      render :new
    end
  end

  def edit
    @repository = Repository.find params[:id]
  end

  def update
    @repository = Repository.find params[:id]

    if @repository.update(repo_params)
      redirect_to repositories_path
    else
      render :edit
    end
  end

  def destroy
    Repository.find(params[:id]).destroy

    redirect_to repositories_path
  end

  private

  def repo_params
    params.require(:repository).permit(:name, :url)
  end
end
