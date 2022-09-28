class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    # @books = @user.books
    @book = Book.new
    @books =@user.books
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @user = User.find(params[:id])
      @book = Book.all
      render 'show'
    end
  end


  def edit
    @user = User.find(params[:id])
    if @user.id == current_user.id
      render "edit"
    else
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :gprofile_image)
  end

  # def ensure_correct_user
  #   @user = User.find(params[:id])
  #   unless @user == current_user
  #     redirect_to user_path(current_user)
  # end
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end
end
