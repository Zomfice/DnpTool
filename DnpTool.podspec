
Pod::Spec.new do |s|
  s.name             = 'DnpTool'
  s.version          = '1.0.0'
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

  #s.source_files = 'DnpTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DnpTool' => ['DnpTool/Assets/*.png']
  # }

    s.subspec 'Metrics' do |spec|
    spec.source_files = 'DnpTool/Classes/Metrics/**/*'
    end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
