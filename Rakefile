namespace :spec do
  task :mri do
    sh "bacon spec/mocha-on-bacon_spec.rb"
  end

  task :macruby do
    macbacon = `which macbacon`.strip
    if macbacon.empty?
      puts "[!] Skipping tests for the MacBacon gem as the macbacon bin was not found in your load path."
    else
      sh "#{macbacon} spec/mocha-on-bacon_spec.rb"
    end
  end
end

desc "Run the specs with `bacon` and, if found, also with `macbacon`"
task :spec => ["spec:mri", "spec:macruby"]

task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "mocha-on-bacon"
    gemspec.summary = "A Mocha adapter for Bacon"
    gemspec.description = "A Mocha adapter for Bacon, because it's yummy!"
    gemspec.email = "eloy.de.enige@gmail.com"
    gemspec.homepage = "https://github.com/alloy/mocha-on-bacon"
    gemspec.authors = ["Eloy Duran"]
    
    gemspec.add_runtime_dependency("mocha", [">= 0.9.8"])
    # This is hard to do if the user wants to only use it with MacBacon...
    #gemspec.add_runtime_dependency("bacon", [">= 1.1.0"])
    
    gemspec.files = FileList["{lib,spec}/**/*.rb", "LICENSE", "README.md"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
end
