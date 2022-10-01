class BooksController < ApplicationController
  #下記でヘッダーのhome,aboutアイコンを押してもLoginの画面のままを解決
  #ログイン中にURLを入力すると他人が投稿した本の編集ページに遷移できない
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @favorites_count = Favorite.where(book_id: @book.id).count
    @comment = current_user.book_comments.new
  end

  def index
    @book_new = Book.new
    @books = Book.all

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    #before_action :ensure_correct_userに記述&private内にensure_correct_userの記述があるので、
    #下記は書いても書かなくてもいい
    # @book = Book.find(params[:id])
    if @book.user.id == current_user.id
      render "edit"
    else
      redirect_to books_path
    end

  end

  def update
    #before_action :ensure_correct_userに記述&private内にensure_correct_userの記述があるので、
    #下記は書いても書かなくてもいい
    # @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    #before_action :ensure_correct_userに記述&private内にensure_correct_userの記述があるので、
    #下記は書いても書かなくてもいい
    # @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  private

  #ログイン中にURLを入力すると他人が投稿した本の編集ページに遷移できない
  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
