class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
    t.integer   :user
    t.integer   :followed_by

    t.timestamps
    end
  end
end
