class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :trip, index: true

      t.timestamps null: false
    end
    add_foreign_key :articles, :trips
  end
end
