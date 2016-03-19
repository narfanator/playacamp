class AddLegacyCampScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :legacy_camp_score, :int, default: 0
  end
end
