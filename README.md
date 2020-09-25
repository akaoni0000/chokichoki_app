# アプリ名
chokichoki
## サイト概要
安価で美容院に行きたい人と、マネキンではなく実際にお客様の髪で施術をしたい美容師アシスタント、双方の希望を叶えるwebアプリケーションです。 美容院に行くとなると料金が高く身構える人が多いですが、このアプリでは気軽に予約をとることができます。美容師アシスタントの方は自分でメニューを考え作成してスタイリストのように施術することができます。 一般の方は一回の施術に500円、美容師の方は完全無料で使えます。
### サイトテーマ
美容師アシスタントに実際に人の髪をきる経験を提供し、顧客側には低単価で髪をきることができる場を提供する。
### テーマを選んだ理由
このサイトを作る前に、私はスクールのカリキュラムで簡単な本のSNSアプリとチーム開発でECサイトを作成しました。その2つのアプリではメール認証機能やクレジットカード決済などの機能は実装できず、アプリケーションとしての完成度が低いことにモヤモヤしていました。なので、ポートフォリオでは今まで実装してこなかったいろいろな機能を実装して完成度の高いアプリケーションを作成しようと思いました。まず初めに、今までやってこなかった機能で実装してみたいと思った機能は ホットペッパービューティー（美容室予約アプリ）のカレンダーを使った予約機能でした。そこで美容師に焦点を当てたアプリを作成しようと決めました。次にどのような問題を解決できるアプリにするか考え、美容師の知り合いやネットの情報を 調べていき、美容師のアシスタントさんが1年目で離職する割合は約50%となっていることを知りました。その理由の一つにいつになったらお客様の髪が切れるようになるのか分からないまま、技術を磨く日々が夜遅くまで毎日続いてしまうということがあります。 またカットモデルになりたい一般の人も安く髪を切ってもらえるなどの理由でぜひやってみたいが、どこで募集しているかわからない人が多いことがわかりました。実際私も知りませんでした。私はそのどちらの問題も解決したいと思い、スタイリストさんに実際にお客さまの髪を切らせる機会をあたえ、技術を磨き、モチベーションをアップさせる場を与えることができ、 誰もが安価で美容院に行ける、そんなアプリを作成したいと思い作成しました。
### ターゲットユーザ
美容師アシスタント 安価で美容院に行きたい人
### 主な利用シーン
美容師・・・人の髪を練習したいとき<br>
一般の人・・・安価で髪を切りたいとき
### 設計書
https://drive.google.com/file/d/1L9GzhtcA8YSMYTWPJa_tjOHIt_3FVncx/view?usp=sharing
### 機能一覧
https://docs.google.com/spreadsheets/d/1iVJtVIEPOJfK9lpzj4hvO74wDkuwX-_JMYbeXIKvjyk/edit?usp=sharing
## 動画でわかるchokichoki(予約完了までの流れを紹介) 
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
