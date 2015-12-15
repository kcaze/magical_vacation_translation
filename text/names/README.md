Addresses
=========
0x08226F7C contains offsets into names. Byte offsets into 0x08226F7C.
Names are fixed width, each taking up exactly 16 bytes.

0x0000008 = N/A
0x000000C = N/A
0x000003C = Physical attacks (0x08226FB8)
0x0000390 = Item names (0x0822730C)
0x0001394 = Status effects (0x08228310)
0x00014C8 = Spell names (0x08228444)
0x0001D7C = Monster names(0x08228CF8)
0x0003260 = Party member names (0x0822A1DC)
0x00034A4 = Male sign, female sign, question mark (0x0822A420)
0x00034D8 = Spirit names (0x0822A454)
0x00035EC = Species names (0x0822A568)
0x0003730 = Element names (0x0822A6AC)
0x0003854 = Place names (0x0822A7D0)
0x0005478 = Ranking names [on the report card] (0x0822C3F4)

Name hacking
============
In the menu:
  Names MUST end in 0xFFFF? The 0xFFFF is used at 0x080BEE66 to compute the length
  of a name.

  0x080BD5C4 is a small subroutine to compute the beginning address for a name. We
  need to modify this to compute the address properly since each name takes up 32
  bytes and not 16 bytes.

In battle:
  Lots of places need to be modified to shift by 5 instead of 4 since each name
  takes up 32 bytes.
    0x08016DC0 -- Spell names
    0x08016DE8 -- Item names
    0x080157E6 -- Physical attack names

0x080BEDE4 truncates names as it takes in a max width argument in r1. Need to
rewrite a lot of the calls to change the max width argument.

--------------------------------------------------------------------------------
EVERYTHING BELOW IS OLD AND DEPRECATED
--------------------------------------------------------------------------------

We need to hack things to extend it so that each name is 32 bytes long instead.
80BD5C4 is a small subroutine to compute the beginning address for a name.
80B5D48
80bee90

0x080BEDE4 is used to compute the length a name, returning the length in r2.


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
トルーナ -- Oturan
ベナコンチャ -- Wetsomus
レーミッツ -- Erimust Palace
キード・モンガ -- Iko Domnag (がんもどき backwards)
レヒカフ -- Nifkrahs (Shark Fin backwards)
氷の島 -- Ice Island
ジェラ風穴 -- Gelato Cave
クガンデ -- Ukagned Village
ゲアラヴァ -- Ega Aruba Village (Aburaage backwards)
モルビエ火山 -- Mt. Morbier
リギニオ密林 -- Irigino Thicket
キスニカこうざん -- Ikay Ikus Mine (decided to change kanisuki to sukiyaki so it's more recognizable)
シブスト城 -- Chiboust Castle
ラロッシュの塔 -- Tour de La Roche
タンドーリ -- Tandoori
クムヤムト -- Muy Mot (tom yum backwards)
モイロロト -- Omiagan (nagaimo backwards)
モギナスの魔窟 -- Drazzig Grotto (gizzard backwards)
ガスパチ -- Gazpacho  
コヴォマカ -- Okobamak (kamaboko backwards)
ラキューオ -- Arko (Okra backwards)

People names:
ミルフィ -- Mille-feuille
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
アメフラシ -- Nudibrainch or Rainmaker (the pun is lost in direct translation, so these are some attempts at restoring it)
闇の桜文鳥 -- Ricebirds in the Dark Realm (I'm thinking this might want to be Dark Ricebirds instead?)
ムース -- Mousse
ドロ -- Mud (I don't think it should be mud though... that's not a food)
ヌガーリバー -- Nougat
カシュー -- Cashew
ガルバンゾ -- Garbanzo
キヤコタ -- Ikay Okat (takoyaki backwards)
ギーネ -- Igen (negi backwards)
スカンテ -- Arupmet (tempura backwards)
コター -- Supotco (Octopus backwards)
ツベッキャ -- Ecuttel (Lettuce backwards)
ガウショニベ -- Regnig (Ginger backwards)
シブッカ -- Elak (Kale backwards, randomly decided on Kale because it's
                green since I can't make sense of the Japanese name)
ズネヨーマ -- Oyam (Mayo backwards)
リノオア -- Reval (Laver backwards)
キヤシカゥア -- Ikay Ihsaka (akashiyaki backwards, might change this since the food is obscure).
バシュラール -- Bachelard (philosopher)
ウィトゲンシュタイン -- Wittgenstein (philosopher)
ショーペンハウア -- Schopenhauer (philosopher)
メルロポンティ -- Merleau-Ponty (philosopher)
キルケゴール -- Kierkegaard (philosopher)
スピノザ -- Spinoza (philosopher)
フーコー -- Foucault (philosopher)
ヘーゲル -- Hegel (philosopher)
カント -- Kant (philosopher)
デカルト -- Descartes (philsopher)
ラッセル -- Russell (philosopher)
シュタイナー -- Steiner (philosopher)
ガダマー -- Gadamer (philosopher)
ヴェーユ -- Weil (philosopher)
スウェデンボルグ -- Swedenborg (philosopher)
バタイユ -- Bataille (philosopher)
パラケルスス -- Paracelsus (philosopher)
アウグスチヌス -- Augustine (philosopher)
マキアベッリ -- Machiavelli (philosopher)
フランシス -- Francis (philosopher)
ディドロ -- Diderot (philosopher)
スペンサー -- Spencer (philosopher)


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
ブッチーネ3世 -- Buccine III (Italian for conches)

ザフロピーク

アラクネイラ
パラズネイラ

A bunch of the enigma names have official versions in the localization of
Magical Starsign, e.g. http://magicalstarsignmagicalvacation.wikia.com/wiki/Equillekrew

Magic Names:

Electric
コールテスラ -- Call Tesla
パチパチ -- Clap
フラッシャー -- Flash
クリアクロック -- Clear Clock
ライトニング -- Lightning
ダブルテスラ -- Double Tesla
サンダースパーク -- Thunder Spark

Ancient
コールクロック -- Call Clock
ねじロボ --
ぜんまいロボ

Other things:
ほにゃ -- Hoolala (what pots say)
