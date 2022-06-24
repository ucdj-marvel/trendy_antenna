class AddNameToOutfitPoster < ActiveRecord::Migration[7.0]
  def change
    add_column :outfit_posters, :name, :string
  end
end
