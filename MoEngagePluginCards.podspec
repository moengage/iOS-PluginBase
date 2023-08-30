Pod::Spec.new do |s|
    s.name         = 'MoEngagePluginCards'
    s.version      = '1.1.0'
    s.summary      = 'MoEngage Cards Plugin for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.homepage     = 'https://www.moengage.com'
    s.documentation_url = 'https://developers.moengage.com/'
    s.license      = { :type => 'Commercial', :file => 'LICENSE' }
    s.author       = { 'MobileDevs' => 'mobiledevs@moengage.com' }
    s.social_media_url   = 'https://twitter.com/moengage'
    s.platform     = :ios
    s.ios.deployment_target = '11.0'
    
    s.source       = {
                        :git => 'https://github.com/moengage/iOS-PluginBase.git',
                        :tag => 'pluginCards-' + s.version.to_s
                    }

    s.source_files = 'MoEngagePluginCards/**/*'
    s.swift_version = '5.0'
    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngagePluginBase', '>= 4.4.0', '< 4.5.0'
    s.dependency 'MoEngageCards', '>= 4.11.0', '< 4.12.0'

    s.test_spec 'UnitTests' do |ts|
      ts.source_files = 'Tests/MoEngagePluginCardsTests/**/*.swift'
      s.scheme       = { :code_coverage => true }
    end
end
