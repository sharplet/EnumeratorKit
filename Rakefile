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

desc "Synonym for docs:generate"
task :docs => :'docs:generate'

namespace :docs do
  desc "Generate documentation"
  task :generate do
    options = [
      '--project-name', 'EnumeratorKit',
      '--project-company', 'EnumeratorKit',
      '--company-id', 'com.sharplet.EnumeratorKit',
      '--output', 'appledoc',
      '--logformat', 'xcode',
      '--print-information-block-titles',
      '--use-code-order',
      '--create-html',
      '--warn-undocumented-member',
      '--no-create-docset',
      '--no-repeat-first-par',
      '--no-warn-invalid-crossref',
      '--warn-missing-arg'
    ]

    options << '--' << Dir['**/*.h']

    system 'appledoc', *options.flatten
  end
end
