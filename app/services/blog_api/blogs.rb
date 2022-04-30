module BlogApi
  module Blogs
    def self.new_blog(params)
      blog = Blog.new(
        title: params[:title],
        body: params[:body],
        user_id: params[:user_id]
      )

      blog.save!

      return ServiceContract.error('Error saving blog.') unless blog.valid?

      ServiceContract.success(blog)
    end
  end
end