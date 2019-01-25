#
# Be sure to run `pod lib lint Extensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Extensions'
  s.version          = '0.12.4'
  s.summary          = 'Swift Extensions.'
  s.description      = <<-DESC 
    My own Swift extensions 
  DESC

  s.homepage         = 'git@github.com:Starkrimson/Extensions.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Starkrimson' => 'starkrimson@icloud.com' }
  s.source           = { :git => 'git@github.com:Starkrimson/Extensions.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Extensions/Classes/Core/**/*'
    core.resource_bundles = {
      'Localization' => ['Extensions/Localization/*.lproj/*']
    }  
  end
  
  s.subspec 'Rx' do |rx|
    rx.source_files = 'Extensions/Classes/Rx/**/*'
    rx.dependency 'Extensions/Core'
    rx.dependency 'RxSwift', '~> 4.0'
    rx.dependency 'RxCocoa', '~> 4.0'
  end
end
