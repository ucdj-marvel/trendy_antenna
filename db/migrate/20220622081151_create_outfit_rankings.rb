class CreateOutfitRankings < ActiveRecord::Migration[7.0]
  def change
    create_table :outfit_rankings do |t|
      t.references :outfit_detail, null: false, foreign_key: true
      t.references :ranking_type, null: false, foreign_key: true
      t.integer :rank, null: false
      t.integer :year, null: false
      t.integer :month, null: false

      t.timestamps
    end
  end
end
