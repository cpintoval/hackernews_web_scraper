require_relative 'post'
require_relative 'comment'
require 'nokogiri'
require 'open-uri'
require 'pry'

class HNScraper

  class << self

    def create_post_from_url(url)
      doc = Nokogiri::HTML(open(url))
      create_post(doc)
    end

    def create_post_from_file(file_path)
      doc = Nokogiri::HTML(File.open(file_path))
      create_post(doc)
    end

    def create_post(doc)

      # Creating the Post Object and parsing the HTML document to retrieve the information
      title = doc.search('.title > a:nth-child(2)').map { |link| link.inner_text }.first
      url = doc.search('.title > a:nth-child(2)').map { |link| link['href'] }.first
      points = doc.search('.subtext > span:first-child').map { |span| span.inner_text}.first.to_i
      item_id = doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }.first.split("=")[1].to_i
      post = Post.new(title, url, points, item_id)

      # Creating and adding the Comments Objects to the post, parsing the HTML document to get the information
      comments = doc.search('.default')
      comments.each do |comment|
        user_id = comment.search('.comhead > a:first-child').inner_text
        days_ago = comment.search('.comhead > a:nth-child(2)').inner_text
        text = comment.search('.comment > span:first-child').inner_text
        comment_instance = Comment.new(user_id, days_ago, text)
        post.add_comment(comment_instance)
      end

      post

    end

    def print_stats(post)
      puts "Post title: #{post.title}"
      puts "Number of comments: #{post.comments.length}"
      puts "User ID with the most comments: #{post.get_user_most_comments}"
    end

  end

end

# Program executable

if !ARGV.empty?
  if ARGV[0].include?("www") or ARGV[0].include?("http")
    # The user enters a URL
    HNScraper.print_stats(HNScraper.create_post_from_url(ARGV[0]))
  else
    # The user inputs a local file path
    HNScraper.print_stats(HNScraper.create_post_from_file(ARGV[0]))
  end
else
 puts "Specify URL of FilePath to scrape from"
end