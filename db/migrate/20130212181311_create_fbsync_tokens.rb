class CreateFbsyncTokens < ActiveRecord::Migration
  def change
    create_table :fbsync_tokens do |t|
      t.string :value
      t.integer :token_owner_id
      t.string :token_owner_type
      t.datetime :last_expiration_reminder

      t.timestamps
    end
  end
end
