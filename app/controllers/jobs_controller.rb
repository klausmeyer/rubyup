class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:repository).all
  end

  def show
    @job = Job.find params[:id]
  end
end
