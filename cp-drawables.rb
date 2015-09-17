require 'fileutils'

# Usage: 
# ruby cp-drawables.rb ~/Downloads/notifications_assets/Android notifications_gear.png ~/Code/foursquare-android/foursquare-batman/src/main/res ic_notification_landing_gear.png

p ARGV

drawable_dirs = ["drawable-xxxhdpi", "drawable-xxhdpi", "drawable-xhdpi", "drawable-hdpi", "drawable-mdpi"]

src_dir = ARGV[0]
src_drawable = ARGV[1]
dst_dir = ARGV[2]
dst_drawable = ARGV[3]

puts src_dir
puts src_drawable
puts dst_dir
puts dst_drawable

drawable_dirs.each do |dir|
  src_path = src_dir + "/" + dir + "/" + src_drawable
  dst_path = dst_dir + "/" + dir + "/" + dst_drawable
  FileUtils.copy_file(src_path, dst_path)
  puts "Copied #{src_path} to #{dst_path}"
end

puts "Done"
