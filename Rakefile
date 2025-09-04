# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Enable `db:setup` and friends.
require_relative 'example-app/config/application'
Rails.application.load_tasks

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]
