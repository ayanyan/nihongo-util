# Emacsで日本語作文するときに便利かも知れない関数

## 有効にするには

Emacsの設定ファイルに次のコードを書いておきます。

`(require 'nu-fun)`

他の設定は `sample-init.el` を参考にしてください。

## 使える関数

* `nu-kutoten-buffer`: バッファ内の句読点を全て標準句読点に変換する。

* `nu-kutoten-region`: リージョン内の句読点を全て標準句読点に変換する。

* `nu-eisuu-region`: リージョン内の英数記号を全てASCII文字に変換する。

* `nu-toggle-my-kutoten`: 標準句読点を切り替える。

* `nu-multi-lines-to-one-line`: 複数行の文章を一行にまとめる。

* `nu-one-line-to-multi-lines`: 一行の文章を句点で分割する。

## ルール

* 変数 `nu-my-toten` の値が標準の読点、 `nu-my-kuten` の値が標準の句点として扱われます。

* 想定されている句読点記号は、「、」「。」「，」「．」のみです。

## ライセンス

GPLに従います。
