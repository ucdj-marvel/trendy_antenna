class RenameCommandErrorHistoriesClassColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :command_error_histories, :class, :error_class
  end
end
