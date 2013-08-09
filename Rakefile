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

desc "Generate appledocs"
task :docs do
  options = [
    '--project-name', 'EnumeratorKit',
    '--project-company', 'EnumeratorKit',
    '--company-id', 'com.sharplet.EnumeratorKit',
    '--logformat', 'xcode',
    '-o', 'appledoc',
    '-h'
  ]

  options << '--' << Dir['**/*.h']

  system 'appledoc', *options.flatten
end
