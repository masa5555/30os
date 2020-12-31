; hello-os
; TAB=4

		ORG		0x7c00			; プログラムが読み込まれる場所: 0x00007c00 ~ 0x00007dff がブートセクタが読み込まれるアドレス

; FAT12フォーマットフロッピーディスクのための記述

		JMP		entry
		DB		0x90
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

entry:
		MOV		AX, 0			; 0初期化
		MOV		SS, AX
		MOV		SP, 0x7c00
		MOV		DS, AX
		MOV		ES, AX

		MOV		AH, 0x00		; 0x10命令の中でビデオモード設定する関数
		MOV		AL, 0x12		; VGAグラフィックスモードだと後の文字出力で使える
		INT		0x10

		MOV		SI, msg			; msgラベルのアドレスが代入されている

putloop:
		MOV		AL, [SI]		; [SI] = SIの値をメモリ番地として指定
		ADD		SI, 1			; SI += 1;
		CMP		AL, 0			; if (AL == 0) goto fin;
		JE		fin

		MOV		AH, 0x0e		; 0x10命令の中で文字を出力する関数を指定
		MOV		BL, 12			; color codeを指定 赤色
		INT		0x10			; 画面に出力するためのソフトウェア割り込み命令
		JMP		putloop

fin:	
		HLT						; HLTがあることでCPUを使う間隔減らせるらしい
		JMP		fin				; 無限ループ

msg:	
		DB		0x0a, 0x0a		; \n\n
		DB		"hello, OS world day2"
		DB		0x0a			; \n
		DB		0

		; 0x001fe までを 0x00 で埋める (一つ前のメッセージ部分)
		;RESB	0x1fe-$			; os自作入門特有
		RESB 0x7dfe-($-$$)		; 上の行をnasm用に変更
		; $ = 式を含む行の先頭のアセンブリ位置 $$ = 現在のセクションの先頭

		DB		0x55, 0xaa

; ブートセクタ以外の部分

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	4600
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	1469432