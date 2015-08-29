require "bundler/gem_tasks"

desc "run all tests"
task :test do
  Dir.glob("test/test*.rb").each do |file|
    require_relative file
  end
end
