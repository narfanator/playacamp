class AddNeededTicketsToUser < ActiveRecord::Migration
  def change
    add_column :users, :needed_tickets, :integer, default: 0
  end
end
