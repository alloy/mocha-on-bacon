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
