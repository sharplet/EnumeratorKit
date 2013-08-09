task :default => :build

desc "Build release configuration"
task :build do
  system 'xctool -configuration Release -sdk iphoneos6.1 build'
end

desc "Run unit tests"
task :test do
  system 'xctool -configuration Debug -sdk iphonesimulator6.1 test'
end

desc "Clean targets"
task :clean do
  system 'xctool clean'
end
