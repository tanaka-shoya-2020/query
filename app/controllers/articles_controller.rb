class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :move_to_sign_in
  before_action :filter, only: [:edit, :update, :destroy]

  def index
    room_id = current_room.id
    @articles = Article.where(room_id: room_id).paginate(page: params[:page], per_page: 10).order('created_at DESC')
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.valid?
      flash[:success] = '記事が保存されました'
      @article.save
      redirect_to articles_path
    else
      flash.now[:danger] = '記事が保存されませんでした'
      render 'articles/create'
    end
  end

  def show
    @comment = Comment.new
    @comments = Comment.where(article_id: params[:id]).paginate(page: params[:page], per_page: 5)
                       .order('created_at DESC')
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash[:success] = '記事を編集しました'
      @article.valid?
      redirect_to article_path(@article)
    else
      flash.now[:danger] = '記事の編集に失敗しました'
      render :edit
    end
  end

  def destroy
    if @article.destroy
      flash[:success] = '削除に成功しました'
      redirect_to articles_path
    else
      render :show
    end
  end

  def search
    if params[:keyword] == ''
      flash.now[:danger] = 'キーワードを入力してください'
      render 'rooms/index'
      nil
    else
      @articles = Article.search(params[:keyword]).where(room_id: current_room.id)
                         .paginate(page: params[:page], per_page: 5).order('created_at DESC')
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :text).merge(user_id: current_user.id, room_id: current_room.id)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def move_to_sign_in
    if !user_signed_in?
      flash[:danger] = 'ログインしてください'
      redirect_to new_session_path
    elsif !room_logged_in?
      flash[:danger] = 'ルームに入室してください'
      redirect_to new_session_path
    end
  end

  def filter
    if current_user != @article.user
      flash.now[:danger] = '自身の投稿ではありません'
      redirect_to root_path
    elsif current_room != @article.room
      flash.now[:danger] = 'その記事はこのルームのものではないため、編集、削除はできません'
      redirect_to root_path
    end
  end
end
