class UsersController < ApplicationController
  def index
    render json: User.all, each_serializer: UserSerializer
  end

  def show
    user = User.find(params[:id])

    render json: user, serializer: UserSerializer
  end

  def new
    User.new
  end

  def create
    user = User.new params[:user]
    if user.save
      redirect_to action: 'show', id: user.id
    else
      render action: 'new'
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
  end

  def edit
    User.find params[:id]
  end

  def update
    user = User.find params[:id]
    return unless user.update(params[:user])
    redirect_to action: 'show', id: user.id
  end
end
