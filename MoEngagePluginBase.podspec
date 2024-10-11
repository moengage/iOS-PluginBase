Pod::Spec.new do |s|
    require_relative 'Utilities/spec'
    s.extend MoEngagePluginSDK::Spec
    s.define

    s.summary      = 'MoEngage Plugin Base for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.tvos.deployment_target = '11.0'

    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngage-iOS-SDK', '9.20.0'
    s.dependency 'MoEngage-iOS-SDK/InApps'
end
