var glossary = {
/************************************\
*          [[Control Codes]]         *
\************************************/
  // lowercase = script control code, uppercase = menu control code
  "n":"|\\80`", // newline
  "N":"|\\FE\\FF`\\1E",
  "black":"|\\8D`", // change font color to black
  "BLACK":"|\\FA\\FF\\0F\\00",
  "red":"|\\8E`", // change font color to red
  "RED":"|\\FA\\FF\\03\\00",
  "blue":"|\\8F`", // change font color to blue
  "choice":"|\\83`", // dialogue choice
  "end_choice":"|\\84`", // end of dialogue choices marker
  "number":"|\\93`", // number control character
  "var_item":"|\\94`", // item control character, controlled by register
  "font_normal":"|\\1D\\00", // change font to normal
  "pause":"|\\82`", // forces a button press
  "FONT_NORMAL":"|\\1D\\00",
  "font_robot":"|\\1D\\01", // change font to robot
  "FONT_ROBOT":"|\\1D\\01",
  "font_menu":"", // change font to menu
  "FONT_MENU":"",
  "music":"\\7B", // musical note glyph
  "MUSIC":"\\7B",
  "heart":"\\7C", // heart glyph
  "HEART":"\\7C",
  "space":"\\7F", // 8 pixel space
  "SPACE":"\\7F",
/************************************\
*             [[Stats]]              *
\************************************/
  "力":"attack",
  "守り":"defense",
  "精神":"spirit",
  "速さ":"speed",
  "MP回復率":"MP regeneration rate",
/************************************\
*           [[Statuses]]             *
\************************************/
  "ブラインド":"blind",
  "毒":"poison",
  "しびれ":"paralysis",
  "まひ":"stun",
  "石化":"petrified",
  "ねむり":"sleep",
/************************************\
*             [[Items]]              *
\************************************/
  "光の地図":"Map of Light",
  "小さいオカリナ":"Small Ocarina",
  "ウークルの羽":"Ukuru's Feather",
  "虫メガネ":"Magnifying Glass",
  "宮殿のカギ":"Palace Key",
  "モンスター図鑑":"Bestiary",
  "チーズナイフ":"Cheese Knife",
  "職人の魂":"Artisan's Soul",
  "闇の地図":"Map of Darkness",
  "アイスシード":"Icy Seed",
  "種族図鑑":"Encyclopedia",
  "水のヴェール":"Water Veil",
  "こんにゃくイモ":"Putty Pea",
  "魔法の手帳":"Magic Handbook",
  "MD辞典":"MD Dictionary",
  "死の地図":"Map of the Abyss",
  "光のヴェール":"Light Veil",
  "闇のヴェール":"Dark Veil",
  "黄泉の石":"Abyssal Stone",
  "予備":"Preparation",
  "あなあきはっぱ":"Holey Leaf",
  "イボイボはっぱ":"Spiny Leaf",
  "ギザギザはっぱ":"Jaggy Leaf",
  "でこぼこはっぱ":"Raggedy Leaf",
  "カエルグミ緑":"Green Frog",
  "カエルグミ青":"Blue Frog",
  "カエルグミ赤":"Red Frog",
  "ミミズグミ黄":"Yellow Worm",
  "ミミズグミ赤":"Red Worm",
  "ドクナのしっぽ":"Depoison Tail",
  "シビナのしっぽ":"Deparalyze Tail",
  "マヒナのしっぽ":"Unstun Tail",
  "セキナのしっぽ":"Stoneoff Tail",
  "フッカのしっぽ":"Wakey Tail",
  "ファイアーボム":"Blaze Bomb",
  "リキッドボム":"Flood Bomb",
  "ペブルボム":"Quake Bomb",
  "ウインドボム":"Zephyr Bomb",
  "ライトボム":"Sparkle Bomb",
  "アビスボム":"Shadow Bomb",
  "ラヴボム":"Amore Bomb",
  "スパークボム":"Thunder Bomb",
  "ポイズンボム":"Venom Bomb",
  "レイザーボム":"Razor Bomb",
  "レインボウボム":"Rainbow Bomb",
  "ソニックボム":"Sonic Bomb",
  "レトロボム":"Retro Bomb",
  "リーフボム":"Forest Bomb",
  "ライフボム":"Fauna Bomb",
  "バグボム":"Roach Bomb",
  "バンダナ":"Bandana",
  "チューリップ":"Tulip Hat",
  "ウールのぼうし":"Wool Cap",
  "ヘルメット":"Helmet",
  "フルフェイス":"Fencing Mask",
  "ネコマスク":"Cat Ears",
  "アンテナ":"Antenna",
  "モヒカンヘルム":"Mohawk Helmet",
  "スーパーアフロ":"Super Afro",
  "パラボラ":"Comsat Dish",
  "マジックリスト":"Magic Wrist",
  "バオバブリング":"Baobab Wrist",
  "シルバーリング":"Silver Ring",
  "ゴールドリング":"Gold Ring",
  "プラチナリング":"Platinum Ring",
  "肉球ハンド":"Cat Paws",
  "ゴルゴンリング":"Gorgon Brace",
  "クォーツレンズ":"Quartz Lens",
  "デイモンリング":"Demon Brace",
  "フローライト":"Fluorite Lens",
  "ビニールシャツ":"Vinyl Shirt",
  "旅人のシャツ":"Tour Shirt",
  "革のジャケット":"Hide Armor",
  "チェーンメイル":"Chain Mail",
  "リザードスキン":"Lizard Mail",
  "ネコタイツ":"Cat Suit",
  "パンサーシャツ":"Lynx Shirt",
  "プレートメイル":"Plate Mail",
  "ヘビーメタル":"Heavy Metal",
  "カエルのシャツ":"Frog Shirt",
  "木のくつ":"Wooden Clogs",
  "旅人のくつ":"Hiking Shoes",
  "スパイク":"Cleats",
  "つまさきくるん":"Elf Shoes",
  "ラバーソウル":"Rubber Soles",
  "肉球ブーツ":"Cat Feet",
  "鉄のゲタ":"Mechaboots",
  "オストリッチ":"Bird Boots",
  "ガラスのくつ":"Glass Slippers",
  "楽園ブーツ":"Paradise Boots",
  "ぱっちんどめ":"Hair Clip",
  "カチューシャ":"Headband",
  "赤いリボン":"Red Ribbon",
  "ラピスのピアス":"Lapis Studs",
  "ヒスイのピアス":"Jade Studs",
  "ネコすず":"Cat Bell",
  "ドクロのリボン":"Skull Clip",
  "石の魚":"Gorgon's Eye",
  "みみせん":"Ear Plugs",
  "イヌハナ":"Dog Snout",
  "スカンピシェル":"Scampi Shell",
  "クラブシェル":"Crab Shell",
  "トータスシェル":"Tortoise Shell",
  "キメラシェル":"Chimera Shell",
  "ブラックシェル":"Black Shell",
  "シルバーシェル":"Silver Shell",
  "ドラゴンシェル":"Dragon Shell",
  "ユーレロシェル":"Yurero's Shell",
  "ガラスだま":"Glass Bead",
  "ローズクォーツ":"Rose Quartz",
  "アメジスト":"Amethyst",
  "トルマリン":"Tourmaline",
  "サファイア":"Sapphire",
  "ルビー":"Ruby",
  "ダイヤモンド":"Diamond",
  "オリハルコン":"Orichalcum",
  "オレンジの実":"Orange",
  "パパイヤの実":"Papaya",
  "りんごの実":"Apple",
  "マスカットの実":"Muscat",
  "ライチの実":"Lychee",
  "チェリーの実":"Cherry",
  "カシスの実":"Blackcurrant",
  "ドリアンの実":"Durian",
  "赤いキララ":"Red Mica",
  "黄色いキララ":"Yellow Mica",
  "白いキララ":"White Mica",
  "光るキララ":"Shining Mica",
  "輝くキララ":"Sparkling Mica",
  "ウールのせんい":"Wool Fibers",
  "ひつじのガット":"Sheep's Gut",
  "皮ひも":"Leather String",
  "りゅうのひげ":"Dragon's Beard",
  "ニャムワーム":"Neema's Worm",
  "火のシール":"Scorching Sticker",
  "風のシール":"Breezy Sticker",
  "毒のシール":"Noxious Sticker",
  "美のシール":"Graceful Sticker",
  "刃のシール":"Sharp Sticker",
  "音のシール":"Booming Sticker",
  "石のシール":"Boulder Sticker",
  "虫のシール":"Ladybug Sticker",
  "木のシール":"Conifer Sticker",
  "獣のシール":"Animal Sticker",
  "水のシール":"Tidal Sticker",
  "雷のシール":"Electron Sticker",
  "古のシール":"Archaic Sticker",
  "闇のシール":"Stygian Sticker",
  "光のシール":"Radiant Sticker",
  "愛のシール":"Compassion Sticker",
  "レザーキャップ":"Leather Cap",
  "レザーバンド":"Leather Wrist",
  "レザーマント":"Leather Robe",
  "レザーブーツ":"Leather Boots",
  "レザーピアス":"Leather Studs",
  "シーブスハット":"Thief's Hat",
  "シーブスリング":"Thief's Ring",
  "シーブスマント":"Thief's Cloak",
  "シーブスブーツ":"Thief's Boots",
  "シーブスピアス":"Thief's Studs",
  "ウィングハット":"Winged Hat",
  "ウィングリスト":"Winged Bangle",
  "ウィングシャツ":"Winged Shirt",
  "ウィングブーツ":"Winged Boots",
  "ウィングピアス":"Winged Studs",
  "フォースハット":"Force Hat",
  "フォースリング":"Force Ring",
  "フォースマント":"Force Cloak",
  "フォースブーツ":"Force Boots",
  "フォースピアス":"Force Studs",
  "知者のぼうし":"Sage's Hat",
  "知者のうでわ":"Sage's Band",
  "知者のマント":"Sage's Robe",
  "知者のくつ":"Sage's Shoes",
  "知者の指輪":"Sage's String",
  "ミスティハット":"Misty Cap",
  "ミスティリング":"Misty Ring",
  "ミスティマント":"Misty Cloak",
  "ミスティブーツ":"Misty Boots",
  "ミスティピアス":"Misty Studs",
  "賢者のぼうし":"Philosopher's Hat",
  "賢者のうでわ":"Philosopher's Brace",
  "賢者のふく":"Philosopher's Cloak",
  "賢者のくつ":"Philosopher's Shoes",
  "賢者の首かざり":"Philosopher's Pendant",
  "マジカルハット":"Magic Hat",
  "マジカルリング":"Magic Bangle",
  "マジカルマント":"Magic Cloak",
  "マジカルブーツ":"Magic Boots",
  "マジカルピアス":"Magic Studs",
  "ブラックハット":"Black Hat",
  "ブラックリング":"Black Ring",
  "ブラックマント":"Black Cloak",
  "ブラックブーツ":"Black Boots",
  "ブラックピアス":"Black Studs",
  "ホワイトハット":"White Hat",
  "ホワイトリング":"White Ring",
  "ホワイトマント":"White Cloak",
  "ホワイトブーツ":"White Boots",
  "ホワイトピアス":"White Studs",
  "ブラウニハット":"Brownie Hat",
  "ブラウニリング":"Brownie Ring",
  "ブラウニマント":"Brownie Robe",
  "ブラウニブーツ":"Brownie Boots",
  "ブラウニピアス":"Brownie Studs",
  "せんめんき":"Washbasin",
  "てぬぐい":"Towel",
  "ゆかた":"Bathrobe",
  "ゲタ":"Slippers",
  "おふろセット":"Bath Set",
  "トーストキー":"Toasty Key",
  "エアキー":"Gusty Key",
  "ブーキー":"Ivy Key",
  "パウダーキー":"Pretty Key",
  "スラッシュキー":"Edgy Key",
  "ハミングキー":"Melody Key",
  "フリントキー":"Craggy Key",
  "バズキー":"Antsy Key",
  "スティックキー":"Sticky Key",
  "ガルキー":"Furry Key",
  "フローキー":"Rainy Key",
  "テスラキー":"Battery Key",
  "クロックキー":"History Key",
  "ニルヴァキー":"Shadowy Key",
  "ルクスキー":"Brightly Key",
  "ウィッシュキー":"Charity Key",
  "ミーロリ銀貨":"Ignis Coin",
  "アルティ銀貨":"Antiqua Coin",
  "ラシモフ銀貨":"Ventus Coin",
  "クレセント銀貨":"Aqua Coin",
  "ハモニック金貨":"Vox Coin",
  "ヘリオン金貨":"Tonitrus Coin",
  "キャムティ金貨":"Gladius Coin",
  "ガニック金貨":"Decor Coin",
  "まつぼっくり":"Pinecone",
/************************************\
*             [[Spells]]             *
\************************************/
  "コールトースト":"Call Toasty",
  "ホットグリル":"Hot Grill",
  "ヒートフォンデュ":"Heat Fondue",
  "クリアエア":"Clear Gusty",
  "ノヴァショット":"Lava Shot",
  "ダブルトースト":"Double Toasty",
  "黒こげジェット":"Searing Fireball",
  "コールエア":"Call Gusty",
  "アウラー":"Puff Puff",
  "マッハライン":"Mach Nine",
  "クリアブー":"Clear Gloomy",
  "プノエー":"Howler",
  "ダブルエア":"Double Gusty",
  "プレーステール":"Cyclone",
  "コールブー":"Call Gloomy",
  "ポアヴル":"Poivre Poison",
  "ミニュネット":"Grenouille Germ",
  "クリアパウダー":"Clear Pretty",
  "カイエンヌ":"Cayenne Contagion",
  "ダブルブー":"Double Gloomy",
  "グルヌイユ":"Mignonette Miasma",
  "コールパウダー":"Call Pretty",
  "レッドローズ":"Red Rose",
  "イエローローズ":"Yellow Rose",
  "クリアスラッシュ":"Clear Edgy",
  "ブラックローズ":"Black Rose",
  "ダブルパウダー":"Double Pretty",
  "ホワイトローズ":"White Rose",
  "コールスラッシュ":"Call Edgy",
  "コンカッセ":"Batonnet",
  "ジュリエンヌ":"Allumette",
  "クリアハミング":"Clear Catchy",
  "ブロシェット":"Julienne",
  "ダブルスラッシュ":"Double Edgy",
  "エクルヴィス":"Brunoise",
  "コールハミング":"Call Catchy",
  "魂のレクイエム":"Spirit's Requiem",
  "魂のノクターン":"Spirit's Nocturne",
  "クリアフリント":"Clear Rocky",
  "魂のマーチ":"Spirit's March",
  "ダブルハミング":"Double Catchy",
  "魂のオーケストラ":"Spirit's Orchestra",
  "コールフリント":"Call Rocky",
  "ライムロック":"Talc",
  "カテナ":"Fluorite",
  "クリアバズ":"Clear Antsy",
  "ローリングロック":"Quartz",
  "ダブルフリント":"Double Rocky",
  "クライスロック":"Diamond",
  "コールバズ":"Call Antsy",
  "かなぶん":"Locust Swarm",
  "ちょうちょ":"Butterfly Powder",
  "クリアスティック":"Clear Sticky",
  "はち":"Bumblebee Sting",
  "ダブルバズ":"Double Antsy",
  "かぶとむし":"Goliath Charge",
  "コールスティック":"Call Sticky",
  "どんぐりんこ":"Acorn",
  "くるみんこ":"Walnut",
  "クリアガル":"Clear Furry",
  "まつぼっくりんこ":"Pinecone",
  "ダブルスティック":"Double Sticky",
  "いがぐりんこ":"Chestnut",
  "コールガル":"Call Furry",
  "タカのちから":"Hawk Power",
  "サイのちから":"Rhino Power",
  "クリアフロー":"Clear Rainy",
  "ライオンのちから":"Lion Power",
  "ダブルガル":"Double Furry",
  "みんなのちから":"Powers United",
  "コールフロー":"Call Rainy",
  "ブルーカスケード":"Blue Cascade",
  "アシッドスコール":"Acid Rain",
  "クリアテスラ":"Clear Sparky",
  "アクアグラッセ":"Glacial Glaze",
  "ダブルフロー":"Double Rainy",
  "ソーダフラッペ":"Snow Frappe",
  "コールテスラ":"Call Sparky",
  "パチパチ":"Thunder Clap",
  "フラッシャー":"Flasher",
  "クリアクロック":"Clear Early",
  "ライトニング":"Lightning",
  "ダブルテスラ":"Double Sparky",
  "サンダースパーク":"Thunder Spark",
  "コールクロック":"Call Early",
  "ねじロボ":"Robonail",
  "ぜんまいロボ":"Robospring",
  "クリアトースト":"Clear Toasty",
  "はぐるまロボ":"Robogear",
  "ダブルクロック":"Double Early",
  "みさいるロボ":"Robomissile",
  "コールニルヴァ":"Call Inky",
  "ミジョテー":"Mijote",
  "ヘルダイス":"Shadow Die",
  "クリアスピリット":"Clear Spirits",
  "アビス":"Abyssal Void",
  "ダブルニルヴァ":"Double Inky",
  "ブラックホール":"Black Hole",
  "コールルクス":"Call Holy",
  "スターライト":"Sunlight",
  "ムーンライト":"Moonlight",
  "クリアニルヴァ":"Clear Inky",
  "サンライト":"Starlight",
  "ダブルルクス":"Double Holy",
  "スペースライト":"Spacelight",
  "コールウィッシュ":"Call Charity",
  "天使のほほえみ":"Angel's Smile",
  "天使のキッス":"Angel's Kiss",
  "天使のエール":"Angel's Shout",
  "天使のチャージ":"Angel's Charge",
  "ダブルウィッシュ":"Double Charity",
  "天使のハグ":"Angel's Hug",
  "ほのお":"Flamethrower",
  "火のブレス":"Fire Breath",
  "同化":"Assimilate",
  "水のブレス":"Water Breath",
  "三つ目":"Three Eyes",
  "石眼":"Petrify",
  "風のブレス":"Wind Breath",
  "目くらまし":"Smoke Screen",
  "ひかりのおどり":"Dance of Light",
  "光のブレス":"Light Breath",
  "闇のブレス":"Dark Breath",
  "かいふく":"Recovery",
  "ねんりき":"Telekinesis",
  "雷のブレス":"Electric Breath",
  "カビの煙":"Mildew Smoke",
  "くさの祈り":"Grassy Prayer",
  "のろい":"Curse",
  "くさい足":"Smelly Feet",
  "わんわん超音波":"Hypersonic Woof",
  "あわこおり":"Frozen Bubbles",
  "獣のたいぐん":"Beast Army",
  "みわくのかがやき":"Siren's Charm",
  "ツボレーザー":"Razor Pot",
  "暗黒の太陽":"Black Sun",
  "暗黒レーザー":"Black Razor",
  "地震":"Earthquake",
/************************************\
*            [[Spirits]]             *
\************************************/
  "トースト":"Toasty",
  "エア":"Gusty",
  "ブー":"Gloomy",
  "パウダー":"Pretty",
  "スラッシュ":"Edgy",
  "ハミング":"Catchy",
  "フリント":"Rocky",
  "バズ":"Antsy",
  "スティック":"Sticky",
  "ガル":"Furry",
  "フロー":"Rainy",
  "テスラ":"Zappy",
  "クロック":"Early",
  "ニルヴァ":"Inky",
  "ルクス":"Holy",
  "ウィッシュ":"Charity",
/************************************\
*            [[Species]]             *
\************************************/
  "人間":"Human",
  "マッドマン":"Mudmen",
  "愛の大使":"Envoy of Love",
  "ニャムネルト":"Felin",
  "パペット":"Puppet",
  "古代機械":"Ancient Machine",
  "ヴォークス":"Canin",
  "マジックドール":"Magic Doll",
  "こんにゃく様":"Traveling Putty",
  "文鳥":"Ricebird",
  "どーどー":"Dodo",
  "ツボ":"Pot",
  "カエルグミ":"Gummy Frog",
  "ミミズグミ":"Gummy Worm",
  "ブラウニー":"Brownie",
  "エニグマ":"Enigma",
  "ブッチーネ":"Pucine",
  "ワープ屋さん":"Warphat",
  "ピラニア":"Piranha",
  "ドワーフ":"Dwarf",
  "ピップルス":"Souris",
  "アメフラシ":"Rainmaker",
  "パイライト":"Pyrite",
  "ツリーマン":"Treemen",
  "ウォーターピープル":"Water People",
  "星":"Star",
/************************************\
*            [[Elements]]            *
\************************************/
  "火":"Fire",
  "風":"Wind",
  "毒":"Poison",
  "美":"Beauty",
  "刃":"Blade",
  "音":"Sound",
  "石":"Stone",
  "虫":"Bug",
  "木":"Wood",
  "獣":"Beast",
  "水":"Water",
  "雷":"Electric",
  "古":"Ancient",
  "闇":"Dark",
  "光":"Light",
  "愛":"Love",
/************************************\
*          [[Characters]]            *
\************************************/
  "マッシュ":"Marsh",
  "マロウ":"Mallow",
  "キルシュ":"Kirsche",
  "ブルーベリー":"Blueberry",
  "ショコラ":"Chocolat",
  "キャンディ":"Candy",
  "ガナッシュ":"Ganache",
  "ペシュ":"Peche",
  "レモン":"Lemon",
  "カベルネ":"Cabernet",
  "カシス":"Cassis",
  "シードル":"Cider",
  "アランシア":"Arancia",
  "カフェオレ":"Latte",
  "ピスタチオ":"Pistachio",
  "オリーブ":"Olive",
  "セサミ":"Sesame",
  "サーディン":"Sardine",
  "フラウンダ":"Flounder",
  "マッケレル":"Mackerel",
  "ボニート":"Bonito",
  "ターニィ":"Tuna",
  "こんにゃく様":"Traveling Putty",
  "文鳥":"Ricebird",
  "どーどー":"Dodo",
  "ツボ":"Pot",
  "カエルグミ":"Gummy Frog",
  "ブラウン":"Brown",
  "ピスカプーコ":"Pooka",
  "チャッピー":"Chappy",
  "プッチーネ":"Pucine",
  "ギュウヒ・オグラ":"Peabee Anjay",
  "シフォン":"Chiffon",
  "ミルフィ":"Mille-feuille",
  "ティラミス":"Tiramisu",
  "ヌクマム":"Nuoc Mam",
  "ナンプラ":"Nam Pla",
  "メース":"Mace",
/************************************\
*             [[Places]]             *
\************************************/
  "タピオカティ村":"Tapioca Tea Village",
  "マサラティ村":"Masala Chai Village",
  "レヒカフ沼":"Spollacs Swamp",
  "クムヤムト砂漠":"Muy Mot Desert",
  "トルーナ村":"Oturan Village",
  "ベナコンチャ遺跡":"Wetsomus Ruins",
  "ワクティ村":"Hot Tea Village",
  "レーミッツ宮殿":"Cold Honey Palace",
  "キード・モンガ":"Iko Domnag",
  "クガンデ村":"Osim Village",
  "リギニオ密林":"Ecir Thicket",
/************************************\
*            [[Enemies]]             *
\************************************/
  "スノウヘア":"Snowhare",
  "ブッチーネ３世":"Pucine the 3rd",
  "ヘイルクラブ":"Hailcrab",
  "デミッスス":"Demice",
  "ヴァルカネイラ":"Volcanera",
  "アロリーナ":"Arolina",
  "ベルチャーム":"Earl Jam",
  "ノーマジーン":"Jeanorma",
  "ケルレンドゥ":"Kerendu",
/************************************\
*         [[Miscellaneous]]          *
\************************************/
  "愛のデッパリ":"Love Stick",
  "空き":"Unused"
}
