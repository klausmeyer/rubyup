class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:repository).newest_first
  end

  def show
    @job = Job.find params[:id]
  end
end
