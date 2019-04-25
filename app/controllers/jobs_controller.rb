class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:repository).newest_first
  end

  def show
    @job = Job.find params[:id]
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(create_job_params)
    @job.repository_id = params[:job][:repositories].first

    if @job.valid?
      @job.save! # TODO: We need to do this for each repo.
      redirect_to repositories_path
    else
      render :new
    end
  end

  private

  def create_job_params
    params.require(:job).permit(:config)
  end
end
