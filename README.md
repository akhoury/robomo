Robomo
======

Robomo is an application created by PatientsLikeMe used to track incoming product requests. Users can request a feature, then stakeholders can have a discussion, upload attachments, track the progress of the feature, etc.

Environment
-----------
Robomo runs on Ruby on Rails 1.9.3, and is database-agnostic.  (We've tested it with Postgres and SQLite 3, but it should also work with other adapters.)

Test data
---------
There is a rake task to create some test data.  To run it, do:

    bundle exec rake test_data:bootstrap

Logging in
----------
In development and test modes, you can use a gmail account to authenticate.  Stage and production are set up by default to require a patientslikeme.com Google Apps account; to change this, alter the `config.google_auth_domain` setting in production.rb and stage.rb.

License and copyright info
--------------------------
Robomo is Copyright (c) 2012 by PatientsLikeMe, Inc. and is released under the terms and conditions of the MIT license.  For more information, please see the LICENSE file.