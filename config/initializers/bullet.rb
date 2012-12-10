#smart way to configure the developement tool. It will be configured only if gem is present, i.e. in development (as part of gemfile group development)
if defined? Bullet
  Bullet.enable = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.alert = true
end

