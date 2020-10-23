class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title,              null: false 
      t.text   :text,               null: false
      t.references :user,           null: false, foreign_key: true
      t.references :room,           null: false, foreign_key: true
      t.timestamps
    end
  end
end
