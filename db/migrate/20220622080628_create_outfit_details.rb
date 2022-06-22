class CreateOutfitDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :outfit_details do |t|
      t.references :outfit_poster, null: false, foreign_key: true
      t.string :fashion_id, null: false
      t.text :title, null: false
      t.string :img_url, null: false

      t.timestamps
    end
  end
end
