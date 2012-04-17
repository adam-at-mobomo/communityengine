class AddCommentsTables < ActiveRecord::Migration
  def self.up
    create_table :community_engine_comments do |t|
      t.column :title, :string
      t.column :comment, :string
      t.references :commentable, :polymorphic => true
      t.references :user
      t.references :recipient
      t.timestamps      
    end

    add_index :community_engine_comments, ["user_id"], :name => "fk_community_engine_comments_user"
  end

  def self.down
    drop_table :community_engine_comments
  end
end
