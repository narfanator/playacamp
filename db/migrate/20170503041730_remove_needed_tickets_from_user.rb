class RemoveNeededTicketsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :needed_tickets
  end
end
