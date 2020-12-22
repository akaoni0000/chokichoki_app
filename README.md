# アプリ名
chokichoki

## 動画でわかるchokichoki
chokichokiのプレゼン動画です。
https://www.youtube.com/watch?v=mXqwkor7Uts&feature=youtu.be<br>
早くアプリの動きがみたいときは2分25秒から再生することをおすすめします。

## サイト概要
安価で美容院に行きたい人と、マネキンではなく実際にお客様の髪で施術をしたい美容師アシスタント、双方の希望を叶えるwebアプリケーションです。 美容院に行くとなると料金が高く身構える人が多いですが、このアプリでは気軽に予約をとることができます。美容師アシスタントの方は自分でメニューを考え作成してスタイリストのように施術することができます。 一般の方は一回の施術に500円(実際にお金はかかりません)、美容師の方は完全無料で使えます。

### サイトテーマ
美容師アシスタントに実際に人の髪をきる経験を提供し、顧客側には低単価で髪をきることができる場を提供する。

### テーマを選んだ理由
予約システムを使ったアプリを作成しようと考えたときすぐに思い浮かんだのはホットペッパービューティー（美容室予約アプリ）のカレンダーを使った予約機能でした。そこで美容師に焦点を当てたアプリを作成しようと決めました。次にどのような問題を解決できるアプリにするか考え、美容師の知り合いやネットの情報を 調べていき、美容師のアシスタントさんが1年目で離職する割合は約50%となっていることを知りました。その理由の一つにいつになったらお客様の髪が切れるようになるのか分からないまま、技術を磨く日々が夜遅くまで毎日続いてしまうということがあります。 またカットモデルになりたい一般の人も安く髪を切ってもらえるなどの理由でぜひやってみたいが、どこで募集しているかわからない人が多いことがわかりました。私はそのどちらの問題も解決したいと思い、スタイリストさんに実際にお客さまの髪を切らせる機会をあたえ、技術を磨き、モチベーションをアップさせる場を与えることができ、 誰もが安価で美容院に行ける、そんなアプリを作りたいと思い作成しました。

### ターゲットユーザ
美容師アシスタント<br> 
安価で美容院に行きたい人

### 主な利用シーン
美容師アシスタント・・・人の髪を切って練習したいとき<br>
一般の人・・・安価で髪を切りたいとき

### 設計書
https://drive.google.com/file/d/1L9GzhtcA8YSMYTWPJa_tjOHIt_3FVncx/view?usp=sharing
![result](https://github.com/Mac0917/img_for_readme/blob/master/er.png)

### 機能一覧
https://docs.google.com/spreadsheets/d/1iVJtVIEPOJfK9lpzj4hvO74wDkuwX-_JMYbeXIKvjyk/edit?usp=sharing

### 各種バージョン
ruby・・・2.5.7<br>
rails・・・5.2.3<br>
nginx・・・1.19.3<br>
jsフレームワーク・・・jquery<br>
開発環境・・・docker

### メールアドレスについて
このアプリでは実際に使われているメールアドレスしか登録できません。<br>
adminにログインはできますが、メールアドレスは確認できません。

### ローカル環境での実行手順
dockerとdocker-composeを自分のpcにインストール

好きなディレクトリで<br>
`git clone https://github.com/Mac0917/chokichoki-for-docker-nginx-aws-ECS-EC2-.git`

移動<br>
`cd chokichoki-aws`

docker-composeを実行<br>
`docker-compose up -d`

データベース作成<br>
`docker exec -it chokichoki-aws bash`(コンテナに入る)<br>
`rails db:create`<br>
`rails db:migrate`<br>

環境変数を設定(なくても大まかな機能は試せる)<br>
.envファイルを作成<br>
`touch .env`<br>
それぞれの環境変数を設定<br>
KEY = "payjp apiの公開鍵" <br>
SECRET_KEY = "payjp apiの秘密鍵" <br>

GOOGLE_MAP_KEY = "googlemap apiの公開鍵" <br>

TWITTER_CONSUMER_KEY = "twitter apiの公開鍵" <br>
TWITTER_SECRET_KEY = "twitter apiの秘密鍵" <br>

MAIL_PASSWORD = "gmailのパスワード" (gmailは設定でアクセスを許可しておく) <br>

アクセス<br>
http://localhost/<br>

終了<br>
`exit`(コンテナから出る)<br>
`docker-compose stop`<br>
`docker-compose rm`<br>
`docker rmi chokichoki-aws_app chokichoki-aws_web`<br>
`docker volume chokichoki-aws_rm public-data chokichoki-aws_tamp-data chokichoki-aws_db-data`

リポジトリを削除<br>
`cd ..`<br>
`rm -rf chokichoki-aws`

### 3分でchokichokiを試す
会員トップページの右上のログインよりテストデータでログイン > 美容師一覧 > 美容師の一番左上のアンジェラの写真をクリック > メニュー > １分カットを選択 > 適当な時間で予約 > チャット機能で何かメッセージを送る

## 3分でわかるchokichoki(予約完了までの流れを紹介) 
### 美容師登録
新規登録で必要な情報を入力 > メールが届く > メールのurlをクリックするとメール認証完了 
![result](https://github.com/Mac0917/img_for_readme/blob/master/register_hairdresser.png)
![result](https://github.com/Mac0917/img_for_readme/blob/master/hairdresser_mail.png)

### 管理者で美容師の登録を許可
管理者でログイン(フッターにリンクがあります) > 承認待ちより先ほど登録した美容師を選択して承認する > 美容師登録完了
![result](https://github.com/Mac0917/img_for_readme/blob/master/admin.png)

### メニュー作成
美容師でログイン > メニュー作成 > メニューより予定表を編集 > 掲載するを選択
![result](https://github.com/Mac0917/img_for_readme/blob/master/menu.png)
![result](https://github.com/Mac0917/img_for_readme/blob/master/menu2.png)

### 会員登録
新規登録で必要な情報を入力 > メールが届く > メールのurlをクリックするとメール認証完了
![result](https://github.com/Mac0917/img_for_readme/blob/master/register_user.png)
![result](https://github.com/Mac0917/img_for_readme/blob/master/user_mail.png)

### 予約完了
会員(一般人)でログイン > 美容師一覧より美容師を選択 > 美容師のメニューよりメニューを選択 > ご来店日時を選択 > お金を払って予約完了(お金は発生しません)
![result](https://github.com/Mac0917/img_for_readme/blob/master/reserve.png)
![result](https://github.com/Mac0917/img_for_readme/blob/master/reserve_mail.png)

### 施術日までチャット機能でなりたい髪型について話し合おう(スマホバージョン)
チャット画面の入力フォームの上にある二つのアイコンは左が担当美容師が設定した画像を選択でき、右が自分の画像を選択して送信することができます
![result](https://github.com/Mac0917/img_for_readme/blob/master/chat.gif)

## 苦労したところ
予約機能と美容師のマイページにあるヘアスタイルの画像を投稿する複数画像投稿画面のviewページです。
例えば18時に施術時間40分のメニューの予約が入ったら、18時30分には予約を入れられないなど、その前後で予約できなくするメニューを設定するのに苦労しました。
複数画像投稿はメルカリの出品画像登録のviewを参考にしたのですが、typeがfileのinputタグのvalue属性を操作できなかったのでとても苦労しました。

## 追記
・本番環境のテストデータが外国風なのは顔画像のフリー素材に外国人を採用したためです。



