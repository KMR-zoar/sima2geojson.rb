# SIMA to GeoJSON

SIMA ファイル(測量データ 共通フォーマット)を GeoJSON に変換します。

ポイントデータを `.point.geojson` に、画地データを `.polygon.geojson` に出力します。

```
# ./sima2geojson.rb %Path to SIMA File% %Number%
```

`%Path to SIMA File%` には SIMA ファイルまでのパスを、 `%Number%` には平面直角座標系の系番号を入れて実行します。  
SIMA ファイルの拡張子が `.point.geojson` になったファイルと `.polygon,json` になったファイルが作成されると思います。

現在閉合していない画地データもポリゴンとしての変換しかできません。

## todo
+ 路線データを LineString に変換できるようにする

This software is released under the MIT License, see http://opensource.org/licenses/mit-license.php

2015/04/06
+ ポリゴンの頂点座標を格納するキーを変更
+ 系の範囲判定法を変更
+ ポリゴンの属性が nil になってしまう問題を修正

----
Copyright (c) 2015 K'z Minor Release - Zoar