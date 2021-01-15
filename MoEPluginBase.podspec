Pod::Spec.new do |s|
    s.name         = 'MoEPluginBase'
    s.version      = '1.2.1'
    s.summary      = 'MoEngage Plugin Base for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.homepage     = 'https://www.moengage.com'
    s.documentation_url = 'https://docs.moengage.com'
    s.license      = { :type => 'Commercial', :file => 'LICENSE' }
    s.author       = { 'Chengappa C D' => 'chengappa@moengage.com' }
    s.social_media_url   = 'https://twitter.com/moengage'
    s.platform     = :ios
    s.ios.deployment_target = '9.0'
    
    s.source       = {
                        :git => 'https://github.com/moengage/iOS-PluginBase.git',
                        :tag => 'MoEPluginBase-' + s.version.to_s
                    }

    s.source_files = 'MoEPluginBase/**/*'
    s.public_header_files = 'MoEPluginBase/**/*.h'
    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngage-iOS-SDK', '>= 6.3.0', '< 7.0.0'
    s.dependency 'MoEngageInApp', '>= 1.1.0', '< 2.0.0'
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
