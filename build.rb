#!/usr/bin/env ruby

require 'readline'

friendly_rev = ENV["FRIENDLY_REV"] ? ENV["FRIENDLY_REV"].to_s : nil
friendly_rev ||= ARGV[0]

if friendly_rev.nil?
  raise "FRIENDLY_REV and BUILD_NUM environment variables are required"
end

bnum = File.read("./buildnum.txt").strip.to_i
bnum = bnum + 1
File.open("./buildnum.txt", "w") do |f|
  f.puts bnum
end
build_num = bnum

puts "Build #{friendly_rev}(#{build_num})"

files = ["LaunchIt/LaunchItHelper-Info.plist", "LaunchItWrapper/LaunchItWrapper-Info.plist"]

for file in files
  File.open(file, 'r+') do |f|
    lines = f.readlines
    lines = lines.join("")
    lines.gsub!(/CFBundleShortVersionString<\/key>$\s*<string>.*<\/string>/, "CFBundleShortVersionString</key>\n        <string>#{friendly_rev}</string>")
    lines.gsub!(/CFBundleVersion<\/key>$\s*<string>.*<\/string>/, "CFBundleVersion</key>\n        <string>#{build_num}</string>")

    f.pos = 0
    f.print lines
    f.truncate(f.pos)
  end
end

#clean
foo = %x(/Developer/usr/bin/xcodebuild -scheme "Launch it\!" -configuration Release DSTROOT=~/projects/builds DEPLOYMENT_LOCATION=~/projects/builds SYMROOT=~/projects/builds/ clean)
%x(/Developer/usr/bin/xcodebuild -scheme "Launch it\!" -configuration Release DSTROOT=~/projects/builds DEPLOYMENT_LOCATION=~/projects/builds SYMROOT=~/projects/builds/)

# zip it up
%x(ditto -ck --sequesterRsrc --keepParent "/Users/bcooke/projects/builds/Release/Launch it!.app" ~/projects/builds/Release/launchit.#{friendly_rev}.zip)
%x(cp ~/projects/builds/Release/launchit.#{friendly_rev}.zip "/Users/bcooke/Dropbox/[rocket]/Launch it!/builds/launchit.#{build_num.to_s.rjust(4, '0')}_#{friendly_rev}.zip")

#puts "Building trial version..."
#clean
#%x(/Developer/usr/bin/xcodebuild -scheme "Launch it!" -configuration Trial DSTROOT=~/projects/builds DEPLOYMENT_LOCATION=~/projects/builds SYMROOT=~/projects/builds/ clean)
#%x(/Developer/usr/bin/xcodebuild -scheme "Launch it!" -configuration Trial DSTROOT=~/projects/builds DEPLOYMENT_LOCATION=~/projects/builds SYMROOT=~/projects/builds/)

# zip it up
#%x(ditto -ck --sequesterRsrc --keepParent "/Users/bcooke/projects/builds/Trial/Launch it!.app" ~/projects/builds/Trial/launchit.trial.#{friendly_rev}.zip)
#%x(cp ~/projects/builds/Trial/launchit.trial.#{friendly_rev}.zip "/Users/bcooke/Dropbox/[rocket]/Launch it!/builds/launchit.trial.#{friendly_rev}.zip")


%x(open "/Users/bcooke/Dropbox/[rocket]/Launch\ it\!/builds")

# %x(git commit -v -a -m 'new build')
