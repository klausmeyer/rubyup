class IdentitiesController < ApplicationController
  def index
    @identities = Identity.all
  end

  def show
    @identity = Identity.find params[:id]
  end

  def new
    @identity = Identity.new
  end

  def create
    @identity = Identity.new(identity_params)

    if @identity.save
      redirect_to identities_path
    else
      render :new
    end
  end

  def edit
    @identity = Identity.find params[:id]
  end

  def update
    @identity = Identity.find params[:id]

    if @identity.update(identity_params)
      redirect_to identities_path
    else
      render :edit
    end
  end

  def destroy
    Identity.find(params[:id]).delete

    redirect_to identities_path
  end

  private

  def identity_params
    params.require(:identity).permit(:name, :email, :private_key)
  end
end
