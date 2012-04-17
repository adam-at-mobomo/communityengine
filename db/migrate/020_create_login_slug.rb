class CreateLoginSlug < ActiveRecord::Migration
  def self.up
    add_column "community_engine_users", "login_slug", :string
  end

  def self.down
    remove_column "community_engine_users", "login_slug"
  end
end
