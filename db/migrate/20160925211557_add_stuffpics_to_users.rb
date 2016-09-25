class AddStuffpicsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stuffpics, :json
  end
end
