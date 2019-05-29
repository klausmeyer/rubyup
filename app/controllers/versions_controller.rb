class VersionsController < ApplicationController
  def index
    @versions = Version.all.order(:string)
  end

  def new
    @version = Version.new
  end

  def create
    @version = Version.new(version_params)

    if @version.save
      BuildVersionImage.perform_later(@version)
      redirect_to versions_path
    else
      render :new
    end
  end

  private

  def version_params
    params.require(:version).permit(:string)
  end
end
