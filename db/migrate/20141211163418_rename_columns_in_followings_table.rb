class RenameColumnsInFollowingsTable < ActiveRecord::Migration
  def change
    rename_column(:followings, :follower_id, :followed_by)
    rename_column(:followings, :followed_id, :user_id)
  end
end
