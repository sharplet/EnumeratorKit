task :default => [:build]

def xcpretty_sh(cmd)
  unless %x(which xcpretty 2>/dev/null).empty?
    cmd += ' | xcpretty'
    cmd += ' -c' if $stdout.tty?
    cmd += ' -t' if cmd.include? 'test'
  end
  sh cmd
end

xcodebuild_args = "-workspace EnumeratorKit.xcworkspace -scheme EnumeratorKit"

desc "Build release configuration"
task :build do
  xcpretty_sh "xcodebuild #{xcodebuild_args}"
end

desc "Run unit tests"
task :test do
  destination = "platform=iOS Simulator,name=iPhone Retina (4-inch 64-bit)"
  xcpretty_sh "xcodebuild test -destination '#{destination}' #{xcodebuild_args}"
end

desc "Clean targets"
task :clean do
  rm_rf 'Build/'
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
