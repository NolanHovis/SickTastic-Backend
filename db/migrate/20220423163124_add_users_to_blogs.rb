class AddUsersToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :user_id, :int
  end
end
