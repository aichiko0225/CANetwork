#
# Be sure to run `pod lib lint CANetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CANetwork'
  s.swift_version    = '4.2'
  s.version          = '0.1.5'
  s.summary          = 'CCNetwork is a high level request util based on AFNetworking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  CCNetwork is a high level request util based on AFNetworking.
  If you have any other questions, please contact me by email or GitHub.
                       DESC

  s.homepage         = 'https://github.com/aichiko0225/CANetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aichiko66@163.com' => 'aichiko66@163.com' }
  s.source           = { :git => 'https://github.com/aichiko0225/CANetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.default_subspecs = 'Objc'
  
  # objc 的部分代码
  s.subspec 'Objc' do |ss|
    ss.source_files = 'CANetwork/Classes/*.{h,m}'
  end
  
  s.subspec 'Swift' do |ss|
    ss.source_files = 'CANetwork/Classes/*.{swift}'
    
    ss.dependency 'CANetwork/Objc'
  end

  # s.resource_bundles = {
  #   'CANetwork' => ['CANetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.framework = "CFNetwork"
  s.dependency 'AFNetworking', '~> 3.0'
end
