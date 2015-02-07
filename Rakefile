XCODEBUILD_OPTS = "-workspace EnumeratorKit.xcworkspace -scheme EnumeratorKit -derivedDataPath DerivedData"
IPHONE6 = "-destination 'platform=iOS Simulator,name=iPhone 6'"
IPHONE5 = "-destination 'platform=iOS Simulator,name=iPhone 5'"

def xcpretty(cmd)
  sh "set -o pipefail; #{cmd} | xcpretty -c"
end

task :default => [:test]

desc "Run all tests"
task test: %w[test:iphone6 test:iphone5]

namespace :test do
  desc "Test on iPhone 6"
  task :iphone6 do
    xcpretty "xcodebuild test #{XCODEBUILD_OPTS} #{IPHONE6}"
  end

  desc "Test on iPhone 5"
  task :iphone5 do
    xcpretty "xcodebuild test #{XCODEBUILD_OPTS} #{IPHONE5}"
  end
end

desc "Clean the default scheme"
task :clean do
  rm_rf "DerivedData"
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

  desc "Open the documentation in a web browser"
  task :open do
    system 'open', 'appledoc/html/index.html'
  end
end
