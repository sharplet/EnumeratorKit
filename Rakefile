task :default => :build

task :build do
  system 'xctool -configuration Release -sdk iphoneos6.1 build'
end

task :test do
  system 'xctool -configuration Debug -sdk iphonesimulator6.1 test'
end

task :clean do
  system 'xctool clean'
end
