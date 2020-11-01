class CommentsController < ApplicationController
  before_action :set_article, only: [:create, :edit, :update, :destroy]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :filter, only: [:edit, :update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comments = Comment.where(article_id: params[:article_id]).paginate(page: params[:page], per_page: 5).order('created_at DESC')
    if @comment.valid?
      flash[:success] = 'コメントが投稿されました'
      @comment.save
      redirect_to article_path(@article)
    else
      flash.now[:danger] = 'コメントが投稿されませんでした'
      render template: 'articles/show'
    end
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    if @comment.valid?
      flash[:success] = 'コメントが変更されました'
      redirect_to article_path(@article)
    else
      flash.now[:danger] = 'コメントが保存されませんでした'
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = '削除されました'
      redirect_to article_path(@article)
    else
      flash.now[:danger] = '削除に失敗しました'
      render template: 'articles/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
          .merge(user_id: current_user.id, room_id: current_room.id, article_id: params[:article_id])
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def filter
    if !user_signed_in?
      flash[:danger] = 'ログインが必要です'
      redirect_to new_user_session_path
    elsif !room_logged_in?
      flash[:danger] = 'ルームに入室してください'
      redirect_to new_session_path
    elsif current_room != @article.room
      flash[:danger] = 'ルームが異なるためコメントできません'
      redirect_to root_path
    elsif current_user != @comment.user
      flash[:danger] = '自身のコメントではありません'
      redirect_to article_path(@article)
    end
  end
end
