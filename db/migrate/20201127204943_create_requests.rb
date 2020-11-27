# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :email, null: false
      t.belongs_to :book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
