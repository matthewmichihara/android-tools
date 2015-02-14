require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: apk2jar [options]"

  opts.on("-sNAME", "--search=NAME", "Search connected device for name") do |s|
    options[:search] = s
  end
end.parse!

p options
p ARGV

search_term = options[:search].downcase
packages = `adb -d shell pm list packages`.lines.map {|l| l.chomp.downcase.split(":").last}

matches = packages.select {|p| p.include? search_term}
matches.each_with_index do |match, i|
  puts "[#{i}] #{match}"
end

puts "Select an APK"
apk_index = gets.chomp.to_i

package_name = matches[apk_index]
puts "You selected #{package_name}"

package_path = `adb -d shell pm path #{package_name}`.chomp.split(":").last
puts "Package path is #{package_path}"

`adb -d pull #{package_path}`
apk_name = package_path.split("/").last

`tar xvf #{apk_name} classes.dex`
`d2j-dex2jar classes.dex --output #{package_name}.jar`
