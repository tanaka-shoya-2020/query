class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text       :comment,    null: false
      t.references :user,    null: false, foregin_key: true
      t.references :room,    null: false, foregin_key: true
      t.references :article, null: false, foregin_key: true
      t.timestamps
    end
  end
end
