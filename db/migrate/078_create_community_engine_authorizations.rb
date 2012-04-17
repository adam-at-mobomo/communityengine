class CreateCommunityEngineAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :community_engine_authorizations do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :picture_url
      t.string :access_token
      t.string :access_token_secret      
      t.timestamps
    end
  end

  def self.down
    drop_table :community_engine_authorizations
  end
end