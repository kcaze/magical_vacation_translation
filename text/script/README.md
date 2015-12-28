Translation Notes
=================
*Cider is a romanticist. He should sound a bit like Shakespeare.
*Candy is a valley girl.
*Kirsche is a hothead. Maybe it makes sense to sound a bit like a cowboy, idk.
*Maybe "ancient spirit" should be "antiquity spirit"?


Script Addresses
=======
0x00629A2C to be the base address of the script, including offsets.
0x0062C912 to 0x00698E9A is the main script.

Icons
=====
0x0000 to 0x000E inclusive draws various icons instead of text. The icons are
rendered as sprites rather than tiles.
* `0000`: Exclamation point.
* `0001`:
* `0002`: Frog.
* `0003`: Tail.
* `0004`: Bomb.
* `0005`: Headgear.
* `0006`: Armwear.
* `0007`: Bodywear.
* `0008`: Shoes.
* `0009`: Bracelet.
* `000A`:
* `000B`: Seal.
* `000C`:
* `000D`: Book.
* `000E`: Coin.

Control Characters
==================
* `80`: Newline. Function located at `0x0000BA58`. We're overriding this to also perform some cleanup work for our own routine.
* `82`: ??? (perhaps used to indicate progress in the game?)
* `85 00`: Display player's name
* `86 XX`: Display character `XX`'s name.
* `87 XX`: Display item `XX`'s name (I think). `0x0000BC9C` We're overriding this to double the maximum length of names.
* `8B XX`: Display character portrait `XX`.
* `8D`: End using special font (ends 0x8E, 0x8F, 0x90, and 0x91).
* `8E`: Begin using red font.
* `8F`: Begin using blue font.
* `91`: Begin using special katakana set.
* `FF`: Ends dialogue?

0x629A2C to 0x62C6A6-- Offsets into the script for specific dialogue. Each halfword indicates an index into the script. The halfwords are stored in increasing order in "sections". Once one "section" is finished, they start over again at 0x0000 but these are now offsets into the script base address + (number of sections read) * 0x10000. Things are packed VERY tightly. The next offset into the script indicates the end of the current one. There is no separate "end" offset and hence also no control code in the dialogue to indicate the end.

0x0000B564 -- Beginning of subroutine to load next dialogue text. The parameter r0 passed indicates which offset to use.
0x0000B818 -- Does the comparison for control characters.
  0x0000B82C -- FF control character. Branches to 0x0000C2F6.
  0x0000B844 -- Function jump table of control codes, goes from 0x80 to 0xA6 (0x26 control codes total).
  NOTE: I can override some of the jump tables to define my own control codes!!!
0x0000C18E -- Updating the script by 0x2 each read.

0x0000B564 is called at 0x0001CDA4
The beginning of the subroutine for that is at 0x0001CD5C, which is called from
  -0x00000D4C
  -0x00001062
  -0x000170BC
  -0x00017152
  -0x0001CB1C
  -0x0001CCD4
  -0x0001CD0E
  -0x0001CD48
  -0x0001CDA4
  -0x00023700

0x02009720 and 0x020097A0 -- RAM holding location of script that current dialogue is reading from. 0x02009720 is the one that gets incremented after each character is drawn.
0x0200999C -- RAM holding the end of the current dialogue.

`0x00699478`: Some giant address pool. Unsure what these actually point to or
if they are relevant to the script.

0998f1
0b9c05:
0b9c3d


-----------------------------------
Water People's unscrambled stuff (from http://mvdatebook.blog.fc2.com/blog-entry-2.html)
ウォーターピープルの話すアクエリム語とブルーベリーの訳。
赤字のものはゲーム内で赤字で表示されるもの、【】で閉じてあるものはアイテム名です。
ウォーターピープルのセリフは「」で、ブルーベリーのセリフは『』で閉じています。
文字を並び替えると文章になるものに関しては、すべてひらがなに直して掲載しています。
（並び替えに関しては割と雑把なので突っ込みがあればお願いします）


《死の回廊》

「こガハペけ へぺけのペ すしぺ さバめケ プク。」
『運命の3匹のカエルをつかまえろって言ってるわ。
運命の3匹のカエルは他のカエルとは違うみたい。』

「タらナいマ ハにハにゼ ぎガんカ ぬケけル プク。」
『運命のカエルは、緑、青、赤の順に1匹ずつ現れる。
これを3匹つかまえた時に閉じた回廊が開くんだって。』

「なダナ んダ ギぶン ナだナ だンだ んー プク。」
『ここにいる、運命のカエルじゃないカエルは私たちが獲ったカエルの亡霊なんだって。』


《モイロロト村》

「ジんが カいナー おカ ずぐグ ずスな るー プク。」
『死んでから、星に生まれ変わる人もいるらしいわ。
【光のヴェール】があれば、星のふりをして、星の洞窟・ラキューオに入れるって。』

「チやラは ゲぽてっク らベレばラ はンげボけ プク。」
『星の洞窟・ラキューオにいる、闇の大精霊・ブラックカラントが【闇のヴェール】を持ってるって。』

「ぱパプぷ はガペ へけケの ふッケろケ プク。」
『巨大なエニグマが、再生の魔宮に向かったって……。　だから、彼らこの先に行けずにいるんだわ。』

「ミょムん きンホぼ フん ヨんむ どキジゅ プク。」
『再生のための最後の洞窟にはマジックドールは入れない……。なんのことかしら……。』

「ニャか ムリゃ クんおヒゃ ヲク ヒぇひャマ ひェ プク。」
『死んだ人は、死の回廊を通って、再生の魔宮へ行くんだって。
死の回廊に入れるのは、【闇のヴェール】を持つ者だけだって……。』

「エげヴぁ イこンだ エかテ たキう ラんト るマ プク。」
『この子、ついこの前まで光のプレーンにいたんだって。
新しく生まれ変わるためにここに来たって言ってるわ。』


《ガラムマサラ》

「けズしサ がダ カのレ キいト をサめルせ プク。」
→しずけさが だれかのいきを とめさせる
『次の作品にも登場したいって言ってるわ。いったい何のことかしらね。』

「コほたり キかオた チとハこ ミなハを ズらタしタ プク。」
→ほこりたかき おとこたちは みな はなみずをたらした
『ずっと昔、寒いとこに行ったら凍っちゃったことがあるって。』

「ニいマこコ いコん ブのダいツ マたヤるドしィー プク。」
→いまここに こいんのだいぶつ やどるたましい
『昔は海の一部だったって言ってるわ。』

「ダたカ まケわルだ ケのナつ タっひ タとり デ プク。」
→ただ かけまわるだけのなつ たったひとりで
『カプセルの中に入りたいって言ってるわ。入ってどうするつもりかしら。』

「コせネを テおッチ マをテで タずマみリニ ワるス プク。」
→こねこを せおって まちをでて みずたまりに すわる
『"がんじがらめ"の"がんじ"の意味がわからないって悩んでる。
そんなこと、どうでもいいのに。』

「ハれオ カたイた ヲすタれワ サちイィーヤ なリカ プク。」
→おれは たたかいを わすれた ちいさい かなりや
『食べ物がたくさん書いてある本が欲しいって言ってるわ。』

「ダろドけノら ミをキ キるダしメ くボ プク。」
→どろだらけの きみを だきしめる ぼく
『"みみたぶ"の"たぶ"って何語か聞いてるわ。
何語かと聞かれても、どう答えていいものやら。』

「マあニまリのイてキぃ マあニまリのシでンくィ プク。」
→ありのままにいきて ありのままにしんでいく
『こんなとこまで来てくれてありがとうって言ってる。ちょっと笑っちゃった。』

「ほキうノ にっタ バおンさーモ シかムか ワはカいッた プク。」
→ほうきに のった おばーさんも むかしは かわいかった
『カエルがギタイしていない影もいるらしいわ。』

「ゲゆマがー ナがつテもッて ジゃイなイぃー プク。」
→まゆげがー つながってても いいじゃないー
『カベの穴と、ドーナツの穴は、ものすごく近くから見ると区別がつかないって言ってるわ。
それがどうしたって感じ。』

「セこカのイ ホがトん ナらウ ダぼケくガ のソまウま プク。」
→このせかいが ほんとうなら ぼくだけが うそのまま
『この子、カードになりたいって言ってるわ。そんなこと言われても答えようがないわよね。』

「けレぽ ケっポ ハケれポ コけッぽ ホんゲ プク。」
『モンスターの影に見えるのは本当はカエルなんだって。なんのことかしら。』

「アおサ カのン テじん ガしゃ ニぞヌ すクれマたシま プク。」
→おかあさんの じてんしゃが ぞくに ぬすまれました
(ヌルの場合)『モンスターにギタイしているカエルを見つけると……
キヤシカゥアのツボが要求するカエルの数が減るんだって。
緑のカエルなら2個、青のカエルなら1個。』

(オニの場合)『モンスターにギタイしているカエルを見つけると……
キヤシカゥアのツボが要求するカエルの数が減ることがあるんだって。
緑のカエルだったら1個減るけど青のカエルは減らないんだって。』

「チゃぎンボ エみテぁ リっクう モこシら てシっピゅー プク。」
(ヌルの場合)『キヤシカゥアのツボが要求するカエルの数は……
緑や青のカエルを入れると、1個増えて、赤のカエルを入れると1にもどる……。』

(オニの場合)『キヤシカゥアのツボが要求するカエルの数は……
緑のカエルを入れると、2個増えて、青のカエルを入れると1個増える……。
そして、赤のカエルを入れても何も変わらない。』

並び替えに協力してくださった方に感謝！
