# ~/rails_template.rb

gem_group :development, :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "rspec-rails
  gem "shoulda-matchers"
  gem "faker"
end

gem_group :production, :staging do
  gem "rails_12factor"
end

scss = <<-SCSS
@import "*";
SCSS

run "echo '#{scss}' >> app/assets/stylesheets/application.scss"
run "rm app/assets/stylesheets/application.css"
run "rm README.rdoc"
run "echo '# #{@app_name.titleize}' >> README.md"

run("bundle install")

generate("rspec:install")
rake("db:create")

run "echo 'require \"capybara/rails\"' >> spec/rails_helper.rb"

git :init
git add: "."
git commit: "-a -m initial setup"
