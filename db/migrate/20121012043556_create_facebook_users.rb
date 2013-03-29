class CreateFacebookUsers < ActiveRecord::Migration
  def change
    create_table :facebook_users do |t|
      t.text     :facebook_id
      t.text     :first_name
      t.text     :last_name
      t.text     :email
      t.boolean  :deleted, :default => false
      t.timestamps
    end
  end
end