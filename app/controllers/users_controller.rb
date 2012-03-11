class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:home, :show, :followings]
  
  def home
  end

  def show
    @user = User.find(params[:id])
  end

  def followings
    @user = User.find(params[:id])
    @brands = @user.followings.reverse
    render layout: false
  end

  def found_brands
    @user = User.find(params[:id])
    @brands = @user.found_brands.desc(:created_at)
    render "followings", layout: false
  end
end