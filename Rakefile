require 'fileutils'
require 'optparse'
require 'ostruct'

module MoEngagePluginSDK
  EXAMPLES = 'Examples'
  WORKSPACE = File.join(EXAMPLES, 'MoEngagePluginBase.xcworkspace')
  LOCK = File.join(EXAMPLES, 'Podfile.lock')
  TUIST = File.join(`brew --prefix`.strip, 'bin', 'tuist')
end

file MoEngagePluginSDK::TUIST do
  system('brew install --formula tuist@4.61.1 --force', out: STDOUT, exception: true)
end

directory MoEngagePluginSDK::WORKSPACE
file MoEngagePluginSDK::WORKSPACE => MoEngagePluginSDK::TUIST do
  Dir.chdir(MoEngagePluginSDK::EXAMPLES) do
    system('tuist generate --no-open', out: STDOUT, exception: true)
  end
end

file MoEngagePluginSDK::LOCK => [MoEngagePluginSDK::WORKSPACE] do
  Dir.chdir(MoEngagePluginSDK::EXAMPLES) do
    system('pod install', out: STDOUT, exception: true)
  end
end

desc <<~DESC
  Setup project for running
DESC
task :setup => [MoEngagePluginSDK::TUIST] do |t|
  FileUtils.rm(MoEngagePluginSDK::LOCK) if File.exist?(MoEngagePluginSDK::LOCK)
  Dir.chdir(MoEngagePluginSDK::EXAMPLES) do
    system('tuist install', out: STDOUT, exception: true)
    system('tuist generate --no-open', out: STDOUT, exception: true)
    system("pod install", out: STDOUT, exception: true)
  end
end
