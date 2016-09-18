class AddBikePicToUser < ActiveRecord::Migration
  def change
    add_column :users, :bikepic, :string
  end
end
