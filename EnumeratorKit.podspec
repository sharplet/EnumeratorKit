Pod::Spec.new do |s|
  s.name         = "EnumeratorKit"
  s.version      = "0.1"
  s.summary      = "Ruby-style enumeration in Objective-C."

  s.homepage     = "http://github.com/sharplet/EnumeratorKit"
  s.license      = 'MIT'
  s.author       = { "Adam Sharp" => "adsharp@me.com" }
  s.source       = { :git => "file:///Users/adsharp/src/EnumeratorKit", :tag => "#{s.version}" }

  s.source_files = 'EnumeratorKit/EnumeratorKit.h'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |e|
    e.source_files = 'EnumeratorKit/Core'

    e.dependency 'EnumeratorKit/EKFiber'
  end

  s.subspec 'EKFiber' do |f|
    f.source_files = 'EnumeratorKit/EKFiber'
  end

  s.requires_arc = true
end
