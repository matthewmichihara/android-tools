require 'optparse'

def get_installed_packages()
  output = `adb -d shell "pm list packages"`

  installed_packages = []
  output.split("\n").each do |package|
    installed_packages << package[package.index(":") + 1, package.length()].strip
  end

  installed_packages
end

def get_diff()
  saved_packages = []
  File.open("saved.txt", "r") do |file|
    while (line = file.gets)
      saved_packages << line.strip()
    end
  end
  installed_packages = get_installed_packages()
  packages_to_remove = installed_packages - saved_packages
end


options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: checkpoint [options]"

  options[:save] = false
  opts.on("-s", "--save", "Save currently installed apps as checkpoint to restore to") do
    options[:save] = true
  end

  options[:restore] = false
  opts.on("-r", "--restore", "Restore to previously saved checkpoint") do
    options[:restore] = true
  end

  options[:diff] = false
  opts.on("-d", "--diff", "Show new packages since last save") do
    options[:diff] = true
  end

  opts.on("-h", "--help", "Display this screen") do
    puts opts
    exit
  end
end

optparse.parse!

if options[:save]
  installed_packages = get_installed_packages()
  puts installed_packages
  puts "Saving #{installed_packages.size()} installed packages to saved.txt"

  File.open("saved.txt", "w") do |file|
    installed_packages.each do |package|
      file.write(package + "\n")
    end
  end
elsif options[:restore]
  if not File.exist? "saved.txt"
    puts "Run with --save first to create a checkpoint"
    exit
  end

  packages_to_remove = get_diff()

  puts "About to uninstall #{packages_to_remove.size()} apps..."
  packages_to_remove.each do |package|
    puts " #{package}"
  end

  puts
  puts "Proceed? y/n"
  if gets.strip.downcase == "y"
    packages_to_remove.each do |package|
      puts " Uninstalling #{package}..."
      puts " " + `adb -d uninstall #{package}`
    end
  else
    puts "Doing nothing"
  end
elsif options[:diff]
  if not File.exist? "saved.txt"
    puts "Run with --save first to create a checkpoint"
    exit
  end

  diff = get_diff()
  puts "New Apps since last save"
  diff.each do |package|
    puts " #{package}"
  end
else
  puts optparse.help()
end

