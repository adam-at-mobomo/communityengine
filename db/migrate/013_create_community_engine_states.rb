class CreateCommunityEngineStates < ActiveRecord::Migration
  def self.up
    create_table :community_engine_states do |t|
      t.column :name, :string
    end
    add_column "community_engine_users", "state_id", :integer
  end

  def self.down
    drop_table :community_engine_states
    remove_column "community_engine_users", "state_id"
  end
end
