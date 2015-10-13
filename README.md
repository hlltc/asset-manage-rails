##General Information##

Asset-manage-rails: mobile assets management REST APIs based on Ruby on Rails.
**Basic functions**:
    1. It stores your mobile project asset files, like `css/image/config` files etc. 
    2. For every asset, there are serval corresponding variants, depending on your mobile `device type (all/Android/iPhone/iPad)`, `device resolution (all/320x480/320x568/375x667/414x736/768x1024)` and `language (all/en/zh/de/fr/it)`.
    3. Create/delete/update actions for asset/variant require a `basic http authorization (admin/admin)`.
    4. For every variant, you can upload a specific asset file and download the file by variant `url` field.
    5. `GET 'host:port/v1/variant?asset_id=:id'` to list all variants of asset_id=:id, type/resolution/language not specified;
    6. `GET 'host:port/v1/variant?asset_id=:id&device=:device&size=:size&language=:language'` to list all variants of asset_id=:id, type/resolution/language specified. 
    Notes: If there are no items exactly matched, language/resolution/type specification would be changed to 'all' one by one to match items.
    7. Once variant changes or new variant is created, it would notify corresponding mobile devices asynchronizely (*to be finished*).


##Getting Started##
**Requirements**:
    1. ruby 2.1
    2. rails 4.2.4
    3. PostgresSQL 9.4.4
    4. Redis (sidekiq) 3.0.3

**Start Project**:
```ruby
bundle install
rake db:create
db:migrate
bundle exec sidekiq
rails s
```

**Demo**:
Please visit [http://asset-manage-rails.herokuapp.com](http://asset-manage-rails.herokuapp.com).

##Testing##
**Requirements**:
    1. PostgresSQL
    2. Redis
**Run tests**:
```ruby
rake test
```
