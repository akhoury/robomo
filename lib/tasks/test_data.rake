# coding: UTF-8

namespace :test_data do
  desc "Bootstrap dev environment with test data"
  task :bootstrap => :environment do
    [
      "john_doe@gmail.com",
      "jane_fonda@gmail.com",
      "jack_green@gmail.com",
      "jill_gill@gmail.com"
    ].each do |u|
      email = u
      name = u.split('@').first.gsub('_', ' ').titleize
      first_name = name.split(' ').first
      last_name = name.split(' ').last
      User.create email: email, name: name, first_name: first_name, last_name: last_name
    end

    require Rails.root.join('lib', 'import')
  end
end

