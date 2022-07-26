Pod::Spec.new do |s|
    s.name         = 'MoEPluginGeofence'
    s.version      = '1.0.0'
    s.summary      = 'MoEngage Plugin Base for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.homepage     = 'https://www.moengage.com'
    s.documentation_url = 'https://developers.moengage.com/'
    s.license      = { :type => 'Commercial', :file => 'LICENSE' }
    s.author       = { 'Chengappa C D' => 'chengappa@moengage.com' }
    s.social_media_url   = 'https://twitter.com/moengage'
    s.platform     = :ios
    s.ios.deployment_target = '10.0'
    
    s.source       = {
                        :git => 'https://github.com/moengage/iOS-PluginBase.git',
                        :tag => 'MoEngageGeofencePlugin-' + s.version.to_s
                    }

    s.source_files = 'MoEPluginGeofence/**/*'
    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngageGeofence', '>= 4.3.0', '< 4.4.0'
    s.dependency 'MoEPluginBase', '>= 3.0.0', '< 3.1.0'
end
