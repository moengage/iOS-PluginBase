Pod::Spec.new do |s|
    require_relative 'Utilities/spec'
    s.extend MoEngagePluginSDK::Spec
    s.define

    s.frameworks = 'UIKit', 'Foundation', 'UserNotifications'
    s.dependency 'MoEngagePluginBase', '>= 4.10.0', '< 4.11.0'
    s.dependency 'MoEngage-iOS-SDK/Cards'

    # s.test_spec 'UnitTests' do |ts|
    #   ts.source_files = 'Tests/MoEngagePluginCardsTests/**/*.swift'
    #   s.scheme       = { :code_coverage => true }
    # end
end
