class CreateRankingTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :ranking_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
