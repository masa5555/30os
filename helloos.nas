; hello-os
; TAB=4

; FAT12フォーマットフロッピーディスクのための記述

		DB		0xeb, 0x4e, 0x90
		DB		"HELLOIPL"		; ブートセクタの名前 (8 byte固定)
		DW		512				; 1セクタの大きさ (512 固定)
		DB		1				; クラスタの大きさ (1セクタ固定)
		DW		1				; FATが始まる位置 (普通1セクタ目)
		DB		2				; FATの個数 (2個固定)
		DW		224				; rootディレクトリ領域の大きさ (普通224エントリ)
		DW		2880			; ドライブの大きさ (2880セクタ固定)
		DB		0xf0			; メディアのタイプ (固定)
		DW		9				; FAT領域の大きさ (固定)
		DW		18				; 1トラックのセクタ数 (18個　固定)
		DW		2				; ヘッド数 (2個　固定)
		DD		0				; 0: パーティションを使わない
		DD		2880			; ドライブの大きさ (2880セクタ固定) 2回目
		DB		0,0,0x29		; 筆者もわからない??
		DD		0xffffffff		; ボリュームのシリアル番号？
		DB		"HELLO-OS   "	; ディスクの名前　(11byte固定)
		DB		"FAT12   "		; フォーマットの名前　(8byte固定)
		RESB	18				; 18byteの空白

; プログラム本体

		DB		0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
		DB		0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
		DB		0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
		DB		0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
		DB		0xee, 0xf4, 0xeb, 0xfd

; メッセージ部分

		DB		0x0a, 0x0a		; \n\n
		DB		"hello, OS world"
		DB		0x0a			; \n
		DB		0

		; 0x001fe までを 0x00 で埋める (一つ前のメッセージ部分)
		;RESB	0x1fe-$			; os自作入門特有
		RESB 0x1fe-($-$$)		; 上の行をnasm用に変更
		; $ = 式を含む行の先頭のアセンブリ位置 $$ = 現在のセクションの先頭

		DB		0x55, 0xaa

; ブートセクタ以外の部分

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	4600
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	1469432