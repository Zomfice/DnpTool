
Pod::Spec.new do |s|
  s.name             = 'DnpTool'
  s.version          = '1.1.9'
  s.summary          = 'A short description of DnpTool.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Zomfice/DnpTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'songchaofeng6@hotmail.com' => 'songchaofeng6@hotmail.com' }
  s.source           = { :git => 'https://github.com/Zomfice/DnpTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  #s.source_files = 'DnpTool/Classes/**/*'
  
    s.resource_bundles = {
        'DnpTool' => ['DnpTool/Assets/*']
    }
    s.subspec 'Common' do |spec|
      spec.source_files = 'DnpTool/Classes/Common/**/*'
    end
    
    s.subspec 'Home' do |spec|
        spec.source_files = 'DnpTool/Classes/Home/**/*'
        spec.dependency 'DnpTool/Common'
        spec.dependency 'DnpTool/Check'
        spec.dependency 'DnpTool/Metrics'
        spec.dependency 'DnpTool/Log'
    end
    
    s.subspec 'Check' do |spec|
        spec.source_files = 'DnpTool/Classes/Check/**/*'
        spec.dependency 'DnpTool/Common'
    end
  
    s.subspec 'Metrics' do |spec|
        spec.source_files = 'DnpTool/Classes/Metrics/**/*'
        spec.dependency 'DnpTool/Common'
    end
    
    s.subspec 'Log' do |spec|
        spec.source_files = 'DnpTool/Classes/Log/**/*'
        spec.dependency 'DnpTool/Common'
    end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
