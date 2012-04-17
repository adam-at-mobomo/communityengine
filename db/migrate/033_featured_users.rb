class FeaturedUsers < ActiveRecord::Migration
  def self.up
    add_column :community_engine_users, :featured_writer, :boolean, :default => false
  end

  def self.down
    remove_column :community_engine_users, :featured_writer
  end
end
