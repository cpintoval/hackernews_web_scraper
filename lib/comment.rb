class Comment

  attr_reader :post, :user_id, :days_ago, :text

  def initialize(post, user_id, days_ago, text)
    @post = post
    @user_id = user_id
    @days_ago = days_ago
    @text = text
  end

end