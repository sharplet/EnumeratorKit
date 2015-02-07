XCODEBUILD_OPTS = "-workspace EnumeratorKit.xcworkspace -derivedDataPath DerivedData"
IPHONE6 = "-scheme EnumeratorKit-iOS -destination 'platform=iOS Simulator,name=iPhone 6'"
IPHONE5 = "-scheme EnumeratorKit-iOS -destination 'platform=iOS Simulator,name=iPhone 5'"
MACOSX = "-scheme EnumeratorKit-OSX -destination 'generic/platform=OS X'"

def xcpretty(cmd)
  sh "set -o pipefail; #{cmd} | xcpretty -c"
end

task default: %w[test]

task ci: %w[test podspec:lint]

desc "Run all tests"
task test: %w[test:iphone6 test:iphone5 test:macosx]

namespace :test do
  desc "Test on iPhone 6"
  task :iphone6 do
    xcpretty "xcodebuild test #{XCODEBUILD_OPTS} #{IPHONE6}"
  end

  desc "Test on iPhone 5"
  task :iphone5 do
    xcpretty "xcodebuild test #{XCODEBUILD_OPTS} #{IPHONE5}"
  end

  desc "Test on Mac OS X"
  task :macosx do
    xcpretty "xcodebuild test #{XCODEBUILD_OPTS} #{MACOSX}"
  end
end

namespace :podspec do
  desc "Validate the podspec"
  task :lint do
    sh "pod lib lint"
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
