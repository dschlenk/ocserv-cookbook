# Encoding: utf-8
require 'kitchen'
require 'cookstyle'
require 'rubocop/rake_task'
require 'foodcritic'

# # Style tests. cookstyle (rubocop) and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    task.options = ['-a']
  end

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      progress: true
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

begin
  require 'rspec/core/rake_task'

  desc 'Run ChefSpec examples'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  puts ">>> Gem load error: #{e}, omitting spec" unless ENV['CI']
end

namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

task default: %w(style spec)
task integration: ['integration']
