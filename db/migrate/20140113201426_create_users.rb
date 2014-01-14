class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :groupme_uid
      t.string :phone_number
      t.string :image_url
      t.string :name
      t.string :email
      t.boolean :sms_enabled
      t.string :access_token
      t.string :groupme_updated
 
      t.timestamps
    end
  end
end
