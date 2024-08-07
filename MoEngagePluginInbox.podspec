Pod::Spec.new do |s|
    require_relative 'Utilities/spec'
    s.extend MoEngagePluginSDK::Spec
    s.define

    s.name         = 'MoEngagePluginInbox'
    s.version      = '3.0.0'
    s.summary      = 'MoEngage Plugin Base for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngagePluginBase', '5.0.0'
    s.dependency 'MoEngage-iOS-SDK/Inbox'
end
