#
# Be sure to run `pod lib lint SwiftQueue.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftQueue'
  s.version          = '0.1.0'
  s.summary          = 'A queue manager, based on OperationQueue and GCD.'
  s.homepage         = 'https://github.com/CatchZeng/SwiftQueue'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CatchZeng' => '891793848@qq.com' }
  s.source           = { :git => 'https://github.com/CatchZeng/SwiftQueue.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'SwiftQueue/Classes/**/*'
end
