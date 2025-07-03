require 'json'
require 'ostruct'

module MoEngagePluginSDK
  @@config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})
  def self.config
    @@config
  end

  module Spec
    def define()
      podspec_path = caller.find do |trace|
        File.extname(trace.split(":")[0]).eql?('.podspec')
      end.split(":")[0]

      podspec = File.basename(podspec_path, File.extname(podspec_path))
      package_index = MoEngagePluginSDK.config.packages.find_index { |package| package.name == podspec }
      package = MoEngagePluginSDK.config.packages[package_index] if package_index

      self.name              = podspec
      self.version           = package.version
      self.homepage          = 'https://www.moengage.com'
      self.documentation_url = 'https://developers.moengage.com'
      self.license           = { :type => 'Commercial', :file => 'LICENSE' }
      self.author            = { 'MobileDev' => 'mobiledevs@moengage.com' }
      self.social_media_url  = 'https://twitter.com/moengage'

      self.source       = {
        :git => 'https://github.com/moengage/iOS-PluginBase.git',
        :tag => package.tagPrefix + self.version.to_s
      }

      self.ios.deployment_target = '13.0'
      self.swift_version = '5.0'
      self.requires_arc = true
      self.source_files = "#{self.name}/**/*"
      self.preserve_paths = "*.md", "LICENSE"

      plugin_base = 'MoEngagePluginBase'
      unless package.name == plugin_base
        plugin_base_index = MoEngagePluginSDK.config.packages.find_index { |package| package.name == plugin_base }
        plugin_base_package = MoEngagePluginSDK.config.packages[plugin_base_index]
        self.dependency plugin_base, plugin_base_package.version
      else
        self.dependency 'MoEngage-iOS-SDK', MoEngagePluginSDK.config.sdkVerMin
      end
      test_file_glob = "Tests/#{self.name}Tests/**/*.{swift}"
      self.test_spec 'Tests' do |ts|
         ts.ios.deployment_target = '13.0'
         ts.source_files = test_file_glob
      end unless Dir.glob(test_file_glob).empty?
    end
  end
end
