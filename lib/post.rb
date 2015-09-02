class Post

  attr_reader :title, :url, :points, :item_id

  def initialize(title, url, points, item_id)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comments = []
  end

  def comments
    @comments
  end

  def add_comment(comment)
    @comments << comment
  end

  def num_comments(user_id)
    @comments.inject(0) do |num, comment|
      num += comment.user_id == user_id ? 1 : 0
      num
    end
  end

  def get_user_most_comments
    @comments.inject do |user, comment|
      num_comments(user) > num_comments(comment.user_id) ? user : comment.user_id
    end
  end

end