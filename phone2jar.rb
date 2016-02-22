require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: apk2jar [options]"

  opts.on("-sNAME", "--search=NAME", "Search connected device for name") do |s|
    options[:search] = s
  end

  opts.on("-d", "--device", "Run on device") do |v|
    options[:device] = v
  end
end.parse!

p options
p ARGV

search_term = options[:search].downcase
adb_base = "adb"
if options[:device] != nil then
  adb_base = "adb -d"
end

packages = `#{adb_base} shell pm list packages`.lines.map {|l| l.chomp.downcase.split(":").last}

matches = packages.select {|p| p.include? search_term}
matches.each_with_index do |match, i|
  puts "[#{i}] #{match}"
end

puts "Select an APK"
apk_index = gets.chomp.to_i

package_name = matches[apk_index]
puts "You selected #{package_name}"

package_path = `#{adb_base} shell pm path #{package_name}`.chomp.split(":").last
puts "Package path is #{package_path}"

`#{adb_base} pull #{package_path} /tmp/`
apk_name = package_path.split("/").last

`tar xvf /tmp/#{apk_name} classes.dex`
`d2j-dex2jar classes.dex --output #{package_name}.jar`
