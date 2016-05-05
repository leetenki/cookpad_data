レシピデータ1万件
=================

#使い方
```
git clone https://github.com/leetenki/cookpad_data.git
cd cookpad_data
perl view_recipes.pl
```

recipes.jsonが1万件分のレシピの生データ.

view_recipes.plの中でrecipes.jsonをパースして表示してる.

使う時はview_recipes.plと同じようにhashアクセスすればOK.

※JSON.pmがないよって言われたら，cpanmでJSON入れておけばOK.

※1万件じゃ足りない場合は，scraping.plを使う．1日ぶん回せば，10万件くらい取ってきてくれる．
