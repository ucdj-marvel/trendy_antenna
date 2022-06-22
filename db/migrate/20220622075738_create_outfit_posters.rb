class CreateOutfitPosters < ActiveRecord::Migration[7.0]
  def change
    create_table :outfit_posters do |t|
      t.references :gender, foreign_key: true
      t.references :hairstyle, foreign_key: true
      t.string :user_id, null: false
      t.string :icon_url
      t.integer :age
      t.integer :height
      t.text :intro

      t.timestamps
    end
  end
end
