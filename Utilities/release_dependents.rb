#!/usr/bin/ruby

# Usage:
# Release dependents based on inputs and package.json version

require 'json'
require 'ostruct'

module MoEngagePluginSDK
  TRUE_VALUES = %w[1 y Y true TRUE True].freeze
end

repo_flag_mapping = {
  'apple-plugin-cards' => 'release-cards',
  'apple-plugin-geofence' => 'release-geofence',
  'apple-plugin-inbox' => 'release-inbox'
}

inputs = JSON.parse(ENV['MO_WORKFLOW_INPUTS'])
config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})
passed_inputs = inputs.filter { |key, value| !repo_flag_mapping.values.include?(key) }
passed_inputs['base-version'] = config.packages.first.version
passed_inputs['sdk-version'] = config.sdkVerMin

repo_flag_mapping.each do |repo, flag|
  next unless MoEngagePluginSDK::TRUE_VALUES.include?("#{inputs[flag]}")
  system("echo '#{JSON.generate(passed_inputs)}' | gh workflow run cd.yml --ref development --repo \"moengage/#{repo}\" --json", out: STDOUT, exception: true)
end
