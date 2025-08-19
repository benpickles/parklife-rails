# frozen_string_literal: true

# Only require the build integration when running from a Parklife CLI command.
#
# This means that the gem can safely be included in the app's Gemfile without
# applying any of its build-time tweaks.
if defined?(Parklife::CLI)
  require_relative 'rails/build_integration'
end
