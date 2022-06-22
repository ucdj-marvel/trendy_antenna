class CreateAcquisitionResults < ActiveRecord::Migration[7.0]
  def change
    create_table :acquisition_results do |t|
      t.integer :command, null: false, default: 0
      t.jsonb :result, null: false, default: {}
      t.date :date, null: false

      t.timestamps
    end

    add_index :acquisition_results, [:command, :date], unique: true
  end
end
