#
# Be sure to run `pod lib lint Oh.Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Oh.Swift'
  s.version          = '0.2.3'
  s.summary          = 'Swift extension and utils.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift extension and utilities.
                       DESC

  s.homepage         = 'https://github.com/Starkrimson/Oh.Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Starkrimson' => 'starkrimson@icloud.com' }
  s.source           = { :git => 'https://github.com/Starkrimson/Oh.Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5'

  s.module_name = 'OhSwift'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Oh.Swift/Classes/Core/**/*'
  end

  s.subspec 'Rx' do |rx|
    rx.source_files = 'Oh.Swift/Classes/Rx/**/*'
    rx.dependency 'RxSwift', '~> 6.2.0'
    rx.dependency 'RxCocoa', '~> 6.2.0'
  end

  # s.resource_bundles = {
  #   'Oh.Swift' => ['Oh.Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
