Pod::Spec.new do |s|
    require_relative 'Utilities/spec'
    s.extend MoEngagePluginSDK::Spec
    s.define
    
    s.name         = 'MoEngagePluginCards'
    s.version      = '2.1.0'
    s.summary      = 'MoEngage Cards Plugin for Hybrid SDKs'
    s.description  = <<-DESC
    MoEngage is a mobile marketing automation company. This framework is used by our plugins built for different hybrid frameworks i.e, Flutter, Cordova, React Native etc.
                     DESC

    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngagePluginBase', '5.1.0'
    s.dependency 'MoEngage-iOS-SDK/Cards'

    # s.test_spec 'UnitTests' do |ts|
    #   ts.source_files = 'Tests/MoEngagePluginCardsTests/**/*.swift'
    #   s.scheme       = { :code_coverage => true }
    # end
end
