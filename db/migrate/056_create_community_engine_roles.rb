class CreateCommunityEngineRoles < ActiveRecord::Migration
  def self.up
    create_table :community_engine_roles do |t|
      t.column :name, :string
    end

    CommunityEngine::Role.enumeration_model_updates_permitted = true
    CommunityEngine::Role.create(:name => 'admin')    
    CommunityEngine::Role.create(:name => 'moderator')
    CommunityEngine::Role.create(:name => 'member')            
    CommunityEngine::Role.enumeration_model_updates_permitted = false
    
    add_column :community_engine_users, :role_id, :integer

    #set all existing users to 'member'
    CommunityEngine.user_class.update_all("role_id = #{CommunityEngine::Role[:member].id}", ["admin = ?", false])
    #set admins to 'admin'
    CommunityEngine.user_class.update_all("role_id = #{CommunityEngine::Role[:admin].id}", ["admin = ?", true])    

    remove_column :community_engine_users, :admin
  end

  def self.down
    drop_table :community_engine_roles
    remove_column :community_engine_users, :role_id
    add_column :community_engine_users, :admin, :boolean, :default => false
  end
end
