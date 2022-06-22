class CreateHairstyles < ActiveRecord::Migration[7.0]
  def change
    create_table :hairstyles do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
