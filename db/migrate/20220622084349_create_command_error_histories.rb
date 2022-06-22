class CreateCommandErrorHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :command_error_histories do |t|
      t.integer :command, null: false, default: 0
      t.string :class
      t.string :message, null: false
      t.text :backtrace
      t.text :html
      t.binary :screen_shot, limit: 10.megabyte
      t.datetime :error_datetime

      t.timestamps
    end
  end
end
