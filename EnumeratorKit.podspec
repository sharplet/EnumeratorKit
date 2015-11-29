Pod::Spec.new do |s|
  s.name         = 'EnumeratorKit'
  s.version      = '1.0.0'

  s.summary      = 'Ruby-style enumeration in Objective-C.'
  s.description  = <<-EOS
    EnumeratorKit is a collection enumeration library modelled after
    Ruby's Enumerable module and Enumerator class.

    It allows you to work with collections of objects in a very
    compact, expressive way, and to chain enumerator operations together
    to form higher-level operations.

    EnumeratorKit extends the Foundation collection classes, and enables
    you to easily include the same functionality in your own custom
    collection classes.
  EOS

  s.requires_arc = true

  s.homepage     = 'https://github.com/sharplet/EnumeratorKit'
  s.license      = 'MIT'
  s.author       = { 'Adam Sharp' => 'adsharp@me.com' }
  s.source       = { :git => 'https://github.com/sharplet/EnumeratorKit.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'EnumeratorKit/EnumeratorKit.h'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |e|
    e.source_files = 'EnumeratorKit/Core'
    e.dependency 'EnumeratorKit/EKFiber'
  end

  s.subspec 'EKFiber' do |f|
    f.source_files = 'EnumeratorKit/EKFiber'
    f.preserve_paths = 'libmill/**/*'
    f.libraries = 'mill'
    f.xcconfig = {
      'HEADER_SEARCH_PATHS[sdk=iphoneos*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release-iphoneos/include/libmill',
      'HEADER_SEARCH_PATHS[sdk=iphonesimulator*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release-iphonesimulator/include/libmill',
      'HEADER_SEARCH_PATHS[sdk=macosx*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release/include/libmill',
      'LIBRARY_SEARCH_PATHS[sdk=iphoneos*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release-iphoneos',
      'LIBRARY_SEARCH_PATHS[sdk=iphonesimulator*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release-iphonesimulator',
      'LIBRARY_SEARCH_PATHS[sdk=macosx*]' => '$(inherited) $(PROJECT_DIR)/EnumeratorKit/libmill/Release',
    }
  end
end
