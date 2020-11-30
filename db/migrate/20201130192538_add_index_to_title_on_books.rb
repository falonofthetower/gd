class AddIndexToTitleOnBooks < ActiveRecord::Migration[6.0]
  def change
    remove_index :books, :title
    add_index :books, :title, unique: true
  end
end
