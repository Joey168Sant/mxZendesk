#
# Be sure to run `pod lib lint MXZendeskWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
$authentication_version = '0.1'

Pod::Spec.new do |s|
  s.name             = 'MXZendeskWrapper'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MXZendeskWrapper.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/x648934/MXZendeskWrapper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'x648934' => 'z344370@santander.com.mx' }
  s.source           = { :git => 'https://github.com/x648934/MXZendeskWrapper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # s.source_files = 'MXZendeskWrapper/Classes/**/*'
  
  s.dependency 'ZendeskAnswerBotSDK'
  s.dependency 'ZendeskChatSDK'
  s.dependency 'ZendeskSupportSDK'
  s.dependency 'MXAuthenticationManager/core', "~> " + $authentication_version

  s.subspec 'core' do |core|
    core.source_files = 'MXZendeskWrapper/Classes/**/*'
    core.resources = "MXZendeskWrapper/Assets/**/*.{storyboard,xib}", 'MXZendeskWrapper/Assets/images/*'
end
  s.subspec 'simulator' do |simulator|
    simulator.dependency 'MXAuthenticationManager/simulator', "~> " + $authentication_version
end
s.subspec 'device' do |device|
  device.dependency 'MXAuthenticationManager/device', "~> " + $authentication_version
end
  # s.resource_bundles = {
  #   'MXZendeskWrapper' => ['MXZendeskWrapper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
