require 'json'
require 'ostruct'

Pod::Spec.new do |s|
  config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})
  podspec_path = caller.find do |trace|
    File.extname(trace.split(":")[0]).eql?('.podspec')
  end.split(":")[0]

  podspec = File.basename(podspec_path, File.extname(podspec_path))
  package_index = config.packages.find_index { |package| package.name == podspec }
  package = config.packages[package_index]

  s.name              = podspec
  s.version           = package.version
  s.homepage          = 'https://www.moengage.com'
  s.documentation_url = 'https://developers.moengage.com'
  s.license           = { :type => 'Commercial', :file => 'LICENSE' }
  s.author            = { 'MobileDev' => 'mobiledevs@moengage.com' }
  s.social_media_url  = 'https://twitter.com/moengage'

  s.source       = {
    :git => 'https://github.com/moengage/iOS-PluginBase.git',
    :tag => package.tagPrefix + s.version.to_s
  }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files = "Sources/#{s.name}/**/*.{swift}"
  s.preserve_paths = "*.md", "LICENSE"

  s.summary      = 'MoEngage Plugin Base for Hybrid SDKs'
  s.description  = <<-DESC
  MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                    DESC

  s.tvos.deployment_target = '13.0'

  s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
  s.dependency 'MoEngage-iOS-SDK', config.sdkVerMin
  s.dependency 'MoEngage-iOS-SDK/InApps'

  test_file_glob = "Tests/#{s.name}Tests/**/*.{swift}"
  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target = '13.0'
    ts.tvos.deployment_target = '13.0'
    ts.source_files = test_file_glob
    ts.requires_app_host = true
    s.scheme = { :code_coverage => true }
  end unless Dir.glob(test_file_glob).empty?
end
