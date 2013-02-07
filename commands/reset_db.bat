call foreman run bundle exec rake db:drop
call foreman run bundle exec rake db:create
call foreman run bundle exec rake db:migrate
call foreman run bundle exec rake db:test:prepare
call foreman run bundle exec rake import:test_users