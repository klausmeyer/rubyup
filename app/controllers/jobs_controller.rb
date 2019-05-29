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

  def retry
    job = Job.find params[:id]
    Jobs::Retry.new(job: job).call
    redirect_to job
  end

  private

  def create_job_params
    params.require(:job).permit(:name, :identity_id, :version_from_id, :version_to_id, :config).to_h.tap do |hash|
      hash[:config] = YAML.load(hash[:config])
    end
  end

  def repositories
    ids = params[:repositories]
    ids = ids.split(',') if ids.is_a? String
    ids || []
  end
end
