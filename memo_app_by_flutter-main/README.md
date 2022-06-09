# memommm

A new Flutter project.

## 現状の仕様

* 基本的な機能（作成・読込・更新・削除）を備えたメモ帳
* メモの中身はSQLiteを用いて管理する
* メモ一覧画面（HomePage）とメモの編集画面(EditView)、画面はこの二つのみ。
* メモ編集画面で保存ボタンを押さない限り、メモの内容は保存されない
* メモはidで管理。現在のメモ一覧のなかから最大のidに1を足したものを新規作成したメモのidとする

## 役割分担について

ひとまず成果物として提出できる程度のものはできていると思うので、各自で追加していきたい機能を追加していく感じでいこうと思います。

あると良さそうな機能の例：
* メモの作成日時、更新日時を記録
* メモのソート（作成日時順やタイトル順など）
* メモの内容がある程度一覧画面からでも見えるようにする
* 一覧画面からメモをスワイプ操作で削除できるようにする
* 新規作成したメモに「○○年▽▽月◇◇日のメモ」などのような初期タイトルを設定しておく
* 編集画面から一覧画面に戻る際、メモの変更が保存されていなければAlertDialogを出して保存するか尋ねる
* 一覧画面のドロワーにバージョン情報を表示する項目を追加する
* メモの内容を外部のアプリケーションで共有できるようにする
* メモの中身をファイル等にエクスポートできるようにする
* 一覧画面のドロワーのヘッダ部に画像などを配置する
* カラーテーマをユーザー側で選択できるようにする
* メモの文字数を表示するようにする

### 注意事項

* SQLiteを利用するのに必要なsqfliteパッケージはwebアプリケーションに対応していない（= webアプリケーションとしての動作確認をしようとするとエラーになる）。そのため、データベースを利用する場合はエミュレーター、もしくは実機での動作確認が必要。
* UIの確認をするときはホットロードが利用できるwebアプリケーションとしての動作確認を推奨。この時、データベース処理に関連するコードはコメントアウトする必要がある（sqflite関連でエラーが発生するため）
* アプリドロワーに色々用意してあるが、とくに実装する予定はない

## ファイル説明

* main.dart : main()があるところ。基本的にいじる必要はない。
* pages/home_page.dart : メモ一覧画面。アプリを起動して一番はじめに出てくる。
* pages/edit_view.dart : メモの編集画面。
* memo_db.dart : データベース関連処理。

急いで作ったので一部、インデントがおかしくなっていたりコードがきたなかったりする箇所があります。申し訳ありません。

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
