class ArticlesController < ApplicationController
  
  def index
    @room = Room.find(current_room.id)
    @articles = @room.articles.includes(:user)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.valid?
      @article.save
      redirect_to articles_path
    else
      flash.now[:danger] = "記事が保存されませんでした"
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      @article.valid?
      redirect_to article_path(@article)
    else
      flash.now[:danger] = "投稿の編集に失敗しました"
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      flash[:success] = "削除に成功しました"
      redirect_to articles_path
    else
      render :show
    end
  end

  private

    def article_params
      params.require(:article).permit(:title, :text).merge(user_id: current_user.id, room_id: current_room.id)
    end
end
