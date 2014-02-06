# ConditionalCapistrano

Only execute a capistrano task when certain path's have changed since the last deploy.

## Installation

Add this line to your application's Gemfile:

    gem 'conditional_capistrano', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conditional_capistrano

## Usage

Simply require the capistrano module in your config/deploy.rb file:

    require 'conditional_capistrano/capistrano'

Then add some options to the tasks you want to only execute when the specified
path's have changed since the last deploy:

    after "key_vault:symlink", "key_vault:check", when_changed: "config/key_vault.yml"
    after "deploy:symlink_configs", "assets:compile", when_changed: %w[app/assets Gemfile Gemfile.lock config/application.rb]

You can either mention single files or whole folders, which will check for any
changes within.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
