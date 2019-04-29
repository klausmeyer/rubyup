class JobsController < ApplicationController
  helper_method :repositories

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
    @job.repository_id = repositories.first

    if @job.valid?
      Jobs::Create.new(blueprint: @job, repositories: repositories).call
      redirect_to jobs_path
    else
      render :new
    end
  end

  private

  def create_job_params
    params.require(:job).permit(:name, :config).to_h.tap do |hash|
      hash[:config] = YAML.load(hash[:config])
    end
  end

  def repositories
    ids = params[:repositories]
    ids = ids.split(',') if ids.is_a? String
    ids || []
  end
end
