    DB 0x00         ; data byte: 1byteだけ書き込み, 文字列も使える
    DW 0x0011       ; data word: 2byte 
    DD 0x00112233   ; data double-word: 4byte

    RESB 10         ; reserve byte: 10byteだけ予約する（0x00で埋める）