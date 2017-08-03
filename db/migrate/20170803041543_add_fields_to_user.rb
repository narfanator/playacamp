class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
    add_column :users, :years, :text, array: true, default: []
    add_column :users, :work_unit, :int, default: 0
  end
end
