class CreateCampScores < ActiveRecord::Migration
  def change
    create_table :camp_scores do |t|
      t.string :preparation
      t.string :build
      t.string :participation
      t.string :contribution
      t.string :teardown
      t.integer :user_id, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
