class Comment

  attr_reader :user_id, :time_ago, :text

  def initialize(user_id, time_ago, text)
    @user_id = user_id
    @time_ago = time_ago
    @text = text
  end

end