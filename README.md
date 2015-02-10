# SIMA to GeoJSON

SIMA ファイル(測量データ 共通フォーマット)を GeoJSON に変換します。

現在はポイントデータのみの変換です。

```
# ./sima2geojson.rb %Path to SIMA File% %Number%
```

`%Path to SIMA File%` には SIMA ファイルまでのパスを、 `%Number%` には平面直角座標系の系番号を入れて実行します。  
SIMA ファイルの拡張子が `geojson` になったファイルが作成されると思います。

現在ポイントデータの変換しかできません。

## todo
+ 路線データを LineString に変換できるようにする
+ 画地データを Polygon に変換できるようにする
+ 系番号が範囲外だった時の警告を付ける
+ 指定された SIMA ファイルの実在性をチェックする

This software is released under the MIT License, see http://opensource.org/licenses/mit-license.php

----
Copyright (c) 2015 K'z Minor Release - Zoar