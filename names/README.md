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
トルーナ -- Troona
ベナコンチャ -- Benaconcha
ミルフィ -- Mille-feuille

People names:
ギュウヒ・オグラ -- Bun Patti
ヴォークス -- Canin
ニャムネルト -- Felin
シフォン -- Angel Food Cake
愛の大使 -- Envoy of Love
戦士風の愛の大使 -- Brave Envoy of Love
タルト -- Tarte
タタン -- Tatin
ムスコさん -- Sonny

Other names:
愛のデッパリ -- Baby bump
