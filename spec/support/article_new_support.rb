module ArticleNewSupport
  def article_new(article)
    expect(page).to have_link('記事を投稿する')
    visit new_article_path
    fill_in 'article[title]', with: article.title
    expect { click_on('投稿する') }.to change { Article.count }.by(1)
    expect(current_path).to eq articles_path
  end
end