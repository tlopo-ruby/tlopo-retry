require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'coveralls/rake/task'

task default: %i[test rubocop]
task test_with_coveralls: [:default, 'coveralls:push']

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

RuboCop::RakeTask.new
Coveralls::RakeTask.new
