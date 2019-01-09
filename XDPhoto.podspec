#
# Be sure to run `pod lib lint XDPhoto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XDPhoto'
  s.version          = '0.1.0'
  s.summary          = '图片导入，列表，浏览'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xjydev@163.com/XDPhoto'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xjydev@163.com' => 'jingyuanx@tujia.com' }
  s.source           = { :git => 'https://gitee.com/xiaodev/XDPhoto.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XDPhoto/Classes/**/*'
  
   s.resource_bundles = {
     'XDPhoto' => ['XDPhoto/Assets/*']
   }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Photos', 'AssetsLibrary'
   s.dependency 'XDTools', '~> 0.2.0'
end