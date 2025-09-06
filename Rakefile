# frozen_string_literal: true
require 'bundler/gem_tasks'

# Enable `db:setup` and friends.
require_relative 'example-app/config/application'
Rails.application.load_tasks

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]
