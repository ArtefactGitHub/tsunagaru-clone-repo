# tsunagaru
https://tsunagaru.space/

- View： slim
- チャット： ActionCable
- ファイルアップロード： CarrierWave、Amazon S3
- デプロイ： Heroku

## Ruby version

- See [`.ruby-version`](https://github.com/ArtefactGitHub/t-repo/blob/master/.ruby-version).

## Rails version

- See [`Gemfile`](https://github.com/ArtefactGitHub/t-repo/blob/master/Gemfile).

## Project initiation

- リポジトリのクローン

```bash
$ git@github.com:ArtefactGitHub/t-repo.git
```

- Gemのインストール

```bash
$ bundle install --path vendor/bundle
```

### Configuration

*ファイルの中身はご自身の環境に合わせて適宜変更してください*


- 環境変数の設定

```bash
AWS_ACCESS_KEY_ID=＜AWS のアクセスキー＞
AWS_REGION=＜AWS のリージョン＞
AWS_S3_BUCKET_NAME=＜AWS S3 のバケット名＞
AWS_SECRET_ACCESS_KEY=＜AWS のシークレットアクセスきー＞
TWITTER_CALLBACK_URL=＜Twitter 認証のコールバックURL＞
```

### Database creation

```bash
$ bundle exec rails db:create
$ bundle exec rails db:migrate
$ bundle exec rails db:seed_fu
```

## Run rails server

```bash
$ bundle exec rails s
```
