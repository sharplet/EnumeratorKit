XCODEBUILD_OPTS = "-derivedDataPath DerivedData"
IPHONE6 = "-workspace EnumeratorKit.xcworkspace -scheme EnumeratorKit-iOS -destination 'platform=iOS Simulator,name=iPhone 6'"
IPHONE5 = "-workspace EnumeratorKit.xcworkspace -scheme EnumeratorKit-iOS -destination 'platform=iOS Simulator,name=iPhone 5'"
MACOSX = "-workspace EnumeratorKit.xcworkspace -scheme EnumeratorKit-OSX -destination 'generic/platform=OS X'"

def xcpretty(cmd)
  sh "set -o pipefail; #{cmd} | xcpretty -c"
end

task default: %w[test]

task ci: %w[test podspec:lint]

namespace :libmill do
  desc "Build libmill for all supported platforms"
  task all: %w[libmill:iphoneos libmill:iphonesimulator libmill:macosx]

  desc "Build libmill for iOS"
  task :iphoneos do
    sh "xcodebuild -project External/libmill.xcodeproj -scheme libmill-iOS -sdk iphoneos -configuration Release SYMROOT='#{ENV["PWD"]}/build'"
  end

  desc "Build libmill for iOS Simulator"
  task :iphonesimulator do
    sh "xcodebuild -project External/libmill.xcodeproj -scheme libmill-iOS -sdk iphonesimulator -configuration Release SYMROOT='#{ENV["PWD"]}/build'"
  end

  desc "Build libmill for Mac OS X"
  task :macosx do
    sh "xcodebuild -project External/libmill.xcodeproj -scheme libmill-OSX -configuration Release SYMROOT='#{ENV["PWD"]}/build'"
  end
end

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
  rm_rf "build"
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
