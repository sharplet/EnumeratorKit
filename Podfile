platform :ios, '5.0'

shared_test_pods = Proc.new do
  pod 'Kiwi', '~> 2.0.6'
end

target :EnumeratorKitTests, :exclusive => true, &shared_test_pods
target :EnumeratorKitDemo, :exclusive => true, &shared_test_pods
