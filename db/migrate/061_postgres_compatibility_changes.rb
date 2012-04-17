class PostgresCompatibilityChanges < ActiveRecord::Migration
  def self.up
    change_column :community_engine_messages, :recipient_deleted, :boolean, :default => false
  end

  def self.down
    change_column :community_engine_messages, :recipient_deleted, :boolean, :default => 0
  end
end
