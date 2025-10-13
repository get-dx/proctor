class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy, :restore]

  def index
    @roles = params[:show_deleted] == 'true' ? Role.with_deleted : Role.all
    @show_deleted = params[:show_deleted] == 'true'
  end

  def deleted
    @roles = Role.only_deleted
    render :index
  end

  def show
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to @role, notice: 'Role was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to @role, notice: 'Role was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_url, notice: 'Role was successfully soft deleted. It can be restored if needed.'
  end

  def restore
    @role.restore
    redirect_to roles_url, notice: 'Role was successfully restored.'
  end

  private

  def set_role
    if action_name == 'restore'
      @role = Role.with_deleted.find(params[:id])
    else
      @role = Role.find(params[:id])
    end
  end

  def role_params
    params.require(:role).permit(:name)
  end
end