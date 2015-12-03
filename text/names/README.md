Character Names
===============
|Address|Japanese Name|English Name|
|-------|-------------|--------------|
|`0x22A1EC`|マロウ|Mallow|
|`0x22A1FC`|キルシュ|Kirsche|
|`0x22A20C`|ブルーベリー|Blueberry|
|`0x22A21C`|ショコラ|Chocolat|
|`0x22A22C`|キャンディ|Candy|
|`0x22A23C`|ガナっシュ|Ganache|
|`0x22A24C`|ペシュ|Peche|
|`0x22A25C`|レモン|Lemon|
|`0x22A26C`|カベルネ|Cabernet|
|`0x22A27C`|カシス|Cassis|
|`0x22A28C`|シードル|Cider|
|`0x22A29C`|アランシア|Arancia|
|`0x22A2AC`|カフェオレ|Cafe au lait|
|`0x22A2BC`|ピスタチオ|Pistachio|
|`0x22A2CC`|オリーブ|Olive|
|`0x22A2DC`|セサミ|Sesame|
|`0x22A2EC`|サーディン|Sardine|
|`0x22A2FC`|フラウンダ|Flounder|
|`0x22A30C`|マッケレル|Mackerel|
|`0x22A31C`|ボニート|Bonito|
|`0x22A32C`|ターニィ|Tuna|
|`0x22A33C`|こんにゃく様|Mr. Konjac|
|`0x22A34C`|文鳥|Ricebird|
There's still more but I haven't played far enough yet.

グラン・ドラゲー = Principal Biscotti
マドレーヌ先生 = Miss Madeleine

Item Names
==========
|Address|Japanese Name|English Name (<= 14 characters)|
|-------|-------------|--------------|
|`0x22730C`|なし|Empty|
|`0x22731C`|光の地図|Map of Light|
|`0x22732C`|小さいオカリナ|Small Ocarina|
|`0x22733C`|ウークルの羽||
|`0x22734C`|虫メガネ|Magnifying Lens|
|`0x22735C`|宮殿のカギ|Palace Key|
|`0x22736C`|モンスター図鑑|Bestiary|
|`0x22737C`|チーズナイフ|Cheese Knife|
|`0x22738C`|職人の魂|Artisan's Soul|
|`0x22739C`|闇の地図|Map of Darkness|
|`0x2273AC`|アイスシード|Ice seed|
|`0x2273BC`|種族図鑑|Species Guide|
|`0x2273CC`|水のヴェール|Water Veil|
|`0x2273DC`|こんにゃくイモ|Konjac Root|
|`0x2273EC`|魔法の手帳|Magic Handbook|
|`0x2273FC`|MD辞典|MD Dictionary|
|`0x22740C`|死の地図|Map of Death|
|`0x22741C`|光のヴェール|Light Veil|
|`0x22742C`|闇のヴェール|Darkness Veil|
|`0x22743C`|黄泉の石|Abyssal Stone|
|`0x22744C`|予備|Preparation|
|`0x22745C`|あなあきはっぱ|Holey Leaf|
|`0x22746C`|イボイボはっぱ|Bumpy Leaf|
|`0x22747C`|ギザギザはっぱ|Spiky Leaf|
|`0x22748C`|ギザギザはっぱ|Rugged Leaf|

See item_names.yaml for complete list.

The subroutine to display the name of an item is located at `0x0000BC9C` We're
overriding this to double the maximum length of names. It branches to
`0x0000BFC0` to do most of the drawing.

`0x00226F80` stores some offsets, indicating the beginning of the items table,
beginning of the names table, etc.


Place names:
マサラティ -- Masala Chai
ワクティ -- Hot Tea
トルーナ -- Troona (should be Oturan)
ベナコンチャ -- Benaconcha (should be Wetsomus)
ミルフィ -- Mille-feuille
レーミッツ -- Cold Honey Palace (No, this should be Fish Dumplings. It's つみれ backwards >.<)
            (Should change this to Erimust Palace)
キード・モンガ -- Hep Met (should be Iko Domnag) (It's がんもどき backwards)
レヒカフ -- Nifkrahs (Shark Fin backwards)
ジェラ風穴 -- Gelato Cave
クガンデ -- Ukagned Village
ゲアラヴァ -- Ega Aruba Village (Aburaage backwards)
モルビエ火山 -- Mt. Morbier
リギニオ密林 -- Irigino Thicket
キスニカこうざん -- Ikay Ikus Mine (decided to change kanisuki to sukiyaki so it's more recognizable)
シブスト城 -- Chiboust Castle
ラロッシュの塔 -- Tour de La Roche

People names:
ギュウヒ・オグラ -- Bun Patti
ヴォークス -- Canin
ニャムネルト -- Felin
シフォン -- Angel Food Cake (maybe just Angel Cake?)
愛の大使 -- Envoy of Love
戦士風の愛の大使 -- Brave Envoy of Love
タルト -- Tarte
タタン -- Tatin
ムスコさん -- Sonny
ヌクマム -- Nuoc Mam
ナンプラ -- Nam Pla
ピップルス -- The Mausses
ヴァン・ブラン -- Vin Blanc
ヴァン・ルージュ -- Vin Rouge
ヴィグネット -- Vinaigrette Sauce
ヴェルト -- Verte Sauce
オロール -- Aurore Sauce
カルディナル -- Cardinal Sauce
グリビッシュ -- Gribiche Sauce
サルミ -- Salmis Sauce
ザンガラ -- Zingara Sauce
シャスール -- Chasseur Sauce
ジュヌヴォワーズ -- Genevoise Sauce
ショロン -- Choron Sauce
スービーズ -- Soubise Sauce
スミタヌ -- Smitane Sauce (?)
ニューバーグ -- Newburg Sauce
ビガラードソース -- Bigarade Sauce
フォワイヨ -- Foyot Sauce
ポワヴラード -- Poivrade Sauce
マデール -- Madeira Sauce
モルネー -- Mornay Sauce
ロベール -- Robert Sauce
マヨネーズ -- Mayonnaise Sauce
ウスター -- Worcestershire Sauce
グレナデン -- Grenadine
ピラニア -- Piranha
ブッチーネ -- Butchine
ココット -- Cocotte ("Shirred Eggs" in French)
パッション -- Passion Fruit
モイロロト -- Omiagan (nagaimo backwards)
デミグラ -- Demi-glace Sauce
ベシャメル -- Bechamel Sauce
アングレーズ -- Anglaise Sauce
メース -- Mace (if there's no other character called nutmeg, that might be a better translation).
カプチーノ -- Cappuccino
パテシエ -- Patissier
クガンデ -- Ukagned (Dengaku backwards)
フランボワーズ -- Framboise
ラズベリー -- Raspberry
チキータ -- Chiquita (banana brand)
マンゴスチン -- Mangosteen
ドロ -- Syrup?
ジョワンビル -- Joinville (sauce)
ソイ -- Soy (sauce)
ホワイト -- White (sauce)
ヴィネガー -- Vinegar (sauce), there's already vinegrette though...
ブッタネスカ -- Puttanesca (sauce)
アラビアータ -- Arrabbiata (sauce)
カルボナーラ -- Carbonara (sauce)
ジュノベーゼ -- Pesto (sauce)
和風キノコ -- Wafu (sauce) (dropping the mushroom)
タルタル -- Tartar (sauce)
ボロネーズ -- Bolognese (sauce)
ムスク -- Musk (not really a food...)
フェンネル -- Fennel
ガンベジ -- Sausage (can't tell what this name is, but it should be a pizza topping)
リヨネーズ -- Lyonnaise (sauce)
ボンバーポット -- Bomber Pot
はじけるポット -- Burster Pot
フグ -- Fugu
キャパマキィ -- Kappamaki
プトマキィ -- Futomaki
ダーティマキィ -- Datemaki
アワビュー -- Awabi
エンギャウア -- Engawa
マヒマヒ -- Mahimahi
マッドマン -- Mudman
クアトロフォルマッジ -- Quattro Formaggi
エシャロット -- Shallot
ガーシュイン -- Gershwin
ギャプロン -- Gaperon (cheese)
バラカ -- Baraka (cheese)
ヌシャテル -- Neufchatel (cheese)
クロミエ -- Coulommiers (cheese)
マンステール -- Muenster (cheese)
リヴァロ -- Livarot (cheese)
タレッジョ -- Taleggio (cheese)
マリボー -- Maribo (cheese)
ダナブルー -- Danish Blue (cheese)
スティルトン -- Stilton (cheese)
サムソー -- Samso (cheese)
カテョカヴァッロ -- Caciocavallo (cheese)
パルミジャーノ -- Parmigiano (cheese)
とくめいきぼう -- Anonymous Hope (not sure)

Other names:
愛のデッパリ -- Baby bump (Not sure about this at all.)
キララ -- Mica
入魂 -- Bewitch
ウーズ熱 -- Ooze Fever

Monster names:

いなまずん -- Thorzeus, or maybe Thoron or Thorgon.

ダミーゴースト -- Dummy Ghost
クロバティー -- Black Batty
アンスティンガー -- Unbox Jellyfish(undead + box jellyfish)
ボロファントム --
ガルシューム --
ブッチョン
スウィーティ -- Sweety?
パラダック -- Paradux
タルタルちゃん -- Tartar Terrier

ザフロピーク

アラクネイラ
パラズネイラ

A bunch of the enigma names have official versions in the localization of
Magical Starsign, e.g. http://magicalstarsignmagicalvacation.wikia.com/wiki/Equillekrew


Other things:
ほにゃ -- Hoolala (what pots say)
