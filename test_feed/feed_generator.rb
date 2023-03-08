require 'csv'
require 'fileutils'

@posts_to_show = []
@usernames = []
@post_all = []

def time_rand
  return Time.now-rand(1000000)
end

def push_to_post_list(post_each)
  # @posts_to_show << {username: name, post: post_each}
  @posts_to_show << post_each
end

def load_post_list(filename = "post.csv")
  # reads each line of csv file, pushes to @posts_to_show
  CSV.foreach(filename) { |line| push_to_post_list(line) }
  puts "Loaded #{@posts_to_show.length} records from #{filename}..."
end

def load_user_list(filename = "usernames.csv")
  # reads list of usernames and display names, pushes to list
  CSV.foreach(filename) { |line| 
    @usernames << line
  }
  puts "Loaded #{@usernames.length} records from #{filename}"
end

def make_user_dirs
  @usernames.each { |username|
    filename_to_make = username[0].split(".")
    if Dir.exist?("./userprofiles/#{filename_to_make[1]}")
      #
    else
      Dir.mkdir "./userprofiles/#{filename_to_make[1]}"
      CSV.open("user_posts.csv","w"){ |csv|
        6.times do
          user_post = []
          #post_time = time_rand.to_s[0..18].split(" ")
          user_post << username[1]
          user_post << username[0]
          user_post << time_rand.to_s[0..18]
          user_post << @posts_to_show[0][0]
          csv << user_post
          @post_all << user_post
          @posts_to_show.shift
        end
      }
      FileUtils.mv("./user_tweets.csv", "./userprofiles/#{filename_to_make[1]}/user_tweets.csv")
    end
  }
end

load_post_list
load_user_list
make_user_dirs

CSV.open("postlist.csv", "w") { |csv| 
  @post_all.each do |post|
    csv << post
  end
}