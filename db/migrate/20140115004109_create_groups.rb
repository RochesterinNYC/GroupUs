class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_id
      t.integer :groupme_updated
    end
  end
end
