#
# Be sure to run `pod lib lint HLJZhongkeControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLJZhongkeControl'
  s.version          = '0.1.4'
  s.summary          = 'A short description of HLJZhongkeControl.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'SDK'

  s.homepage         = 'https://github.com/meili19916/HLJZhongkeControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'meili19916' => '315179118@qq.com' }
  s.source           = { :git => 'https://github.com/meili19916/HLJZhongkeControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'HLJZhongkeControl/Classes/**/*'
  
 s.resource_bundles = {
   'HLJZhongkeControl' => ['HLJZhongkeControl/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'CocoaAsyncSocket', '~> 7.6.5'
s.dependency 'AFNetworking'
s.dependency 'Toast'
end
