# docker is for dev only

### イメージのビルド

```
cd path/to/repository/repository_docker
mkdir postgredata
docker-compose build
```

* config/database.yml
* config/secrets.yml
* config/initializers/devise.rb
これらを`社内ファイルサーバー/90000/repository_tool/secrets/`からコピーする

### コンテナ起動

```
docker-compose up
```

### migrate/seed
```
+docker ps # repositorydocker_web のコンテナID確認(docker-compose up している状態で)
docker exec #{ コンテナID } bundle exec rake db:migrate
docker exec #{ コンテナID } bundle exec rake db:seed
```

### ブラウザでアクセス

`http://localhost:3000`
id, pw は db/seeds 参照

### コンテナ終了

```
docker-compose down
```
