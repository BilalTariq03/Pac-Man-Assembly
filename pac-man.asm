INCLUDE Irvine32.inc
Include macros.inc

BUFFER_SIZE=1000
.data

high_scores struct
    name db 15(?)
    score dd ?
    level db ?
high_scores ends

scores high_scores 10 dup(<>)


buffer BYTE BUFFER_SIZE DUP(?)
    filename BYTE "highscore.txt", 0
    fileHandle HANDLE ?
    namelength DWORD ?
    bytesWritten DWORD ?


username db 15 dup(?)
score dd 0

;players position
xPos BYTE 48
yPos BYTE 20

;ghost1 position
G1XPOS BYTE 52
G1YPOS BYTE 12

;ghost2 position

G2XPOS BYTE 50
G2YPOS BYTE 12
;ghost3 position

G3XPOS BYTE 54
G3YPOS BYTE 12

;ghost4 position

G4XPOS BYTE 58
G4YPOS BYTE 12




mazeArray byte 25 dup(85 dup (0))   ;maze array according to maze drawn
num byte ?  ;used for checking collisions
count dd ?  ;as temp in drawdots
temp2 db ?  ;temp for loop
temp1 db ?  ;temp for loop
temploop dd ?   ;temp for loop
lives db 3  ;lives of player
level db 1  ;level number
time dd 3   ;used for formula for speed of ghost
timeloop1 dd 0  ;ghost1 speed
timeloop2 dd 0  ;ghost2 speed
timeloop3 dd 0  ;ghost3 speed
timeloop4 dd 0  ;ghost14 speed
currentLevel db ?   ;to compare and check if lvl is complete
previousElement1 db ?   ;for ghost1 to check what ghost has gone through
previousElement2 db ?   ;for ghost2
previousElement3 db ?   ;for ghost3
previousElement4 db ?   ;for ghost4
linecount db 0  ;used in no dot zone to skip num of lines
GM1loop db 0    ;for ghost1 to check num of steps it will move before generating next random movement
GM2LOOP DB 0    ;for ghost2
gm3loop db 0    ;for ghost3
gm4loop db 0    ;for ghost4
currentcount1 db 0  ;for ghost1, checking num of steps it has moved
currentcount2 db 0  ;for ghost2
currentcount3 db 0  ;for ghost3
currentcount4 db 0  ;for ghost4
randnum db ?    ;for storing randumnumber
fruitcount word 200     ;time for fruit to wait before appearing
fruitduration word 200  ;time fruit will apear for

scorestring db 4 dup(?)
lvlstring db ?
sizeofstr db 0

.code
main PROC
    call randomize
    call titlescreen
    call menuscreen

   


   exit
    
main endp



;title screen
titlescreen proc
    mov eax,1500
    call delay
    mov eax, cyan 
    shl eax,4
    call SetTextColor

    mov dl,30
    mov dh,10
    call gotoxy
    mov eax,yellow +(black * 16)
    call settextcolor
    mwrite "  ________  ________  ________  ______ ______   ________  ________  "  
    mov dl,30
    mov dh,11
    call gotoxy
    mwrite " |\   __  \|\   __  \|\   ____\|\   _ \  _   \|\   __  \|\   ___  \ ",0  
    mov dl,30
    mov dh,12
     call gotoxy
    mwrite  "  \ \  \|\  \ \  \|\  \ \  \___|\ \  \\\__\ \  \ \  \|\  \ \  \\ \  \ "
    mov dl,30
    mov dh,13
     call gotoxy
    mwrite   "   \ \   ____\ \   __  \ \  \    \ \  \\|__| \  \ \   __  \ \  \\ \  \  "
    mov dl,30
    mov dh,14
     call gotoxy
    mwrite    "    \ \  \___|\ \  \ \  \ \  \____\ \  \    \ \  \ \  \ \  \ \  \\ \  \ "
    mov dl,30
    mov dh,15
     call gotoxy
    mwrite     "     \ \__\    \ \__\ \__\ \_______\ \__\    \ \__\ \__\ \__\ \__\\ \__\ "
    mov dl,30
    mov dh,16
     call gotoxy
    mwrite      "      \|__|     \|__|\|__|\|_______|\|__|     \|__|\|__|\|__|\|__| \|__| "

    mov dl,50
    mov dh,26
    call gotoxy
    mwrite "   ,##.                   ,==."
     mov dl,50
    mov dh,27
    call gotoxy
    mwrite " ,#    #.                 \ o ',"
     mov dl,50
    mov dh,28
    call gotoxy
    mwrite "#        #     _     _     \    \"
     mov dl,50
    mov dh,29
    call gotoxy
    mwrite "#        #    (_)   (_)    /    ; "
    mov dl,50
    mov dh,30
    call gotoxy
    mwrite " `#    #'                 /   .'  "
    mov dl,50
    mov dh,31
    call gotoxy
    mwrite "   `##'                   '=='"
    
                                                                              


    ;taking name  as input
    mov eax,white +(black * 16)
    call settextcolor
    mov dl,35
    mov dh,20
    call gotoxy
    mwrite "Please enter your name\nickname.(Max length 15): "
    mov edx,offset userName
    mov ecx,15
    mov namelength,eax
    call readString
    mov dl,50
    mov dh,23
    call gotoxy
    call waitmsg
    call clrscr

    ret
titlescreen endp

;menu page
menuscreen proc

mov ecx,0
    menu:
    call clrscr
    call drawmenu

    lookforkey:
    mov  eax,50
    call Delay  
    call readkey
    jz lookforkey

    movzx eax,al

    cmp eax,119
    je movup

    cmp eax,115
    je movdown

    cmp eax,13
    je checknext    ;if pressed enter
    jmp menu

    movup:
        cmp ecx,0
        jle menu

        dec ecx
        jmp menu
    movdown:
        cmp ecx,2
        jge menu

        inc ecx
        jmp menu

    checknext:
        cmp ecx,0
        je calldrawWindow
        

        cmp ecx,1
        je callInstructionScreen
        


        cmp ecx,2
        je quit
        
        calldrawWindow:
        call drawwindow
        jmp menu
        
        callInstructionScreen:
        call instructionscreen
        jmp menu

    quit:
      exit

menuscreen endp

;instruction page
InstructionScreen proc
     call clrscr
     mov eax,red
     call settextcolor
     mov dh,2
     mov dl,27
     call gotoxy
     mwrite"|"
     mov dh,2
     mov dl,45
     call gotoxy
     mwrite"|"
     mov dh,1
     mov dl,27
     call gotoxy
     mwrite"___________________"
     mov dh,3
     mov dl,27
     call gotoxy
     mwrite"-------------------"

     mov eax,cyan+(black*16)
     call settextcolor
     
     mov dh,2
     mov dl,30
     call gotoxy
     mwrite "Game Controls"

     mov dh,5
     mov dl,20
     call gotoxy
     mwrite "w"
     mov dh,5
     mov dl,50
     call gotoxy
     mwrite "move up"

     mov dh,7
     mov dl,20
     call gotoxy
     mwrite "s"
     mov dh,7
     mov dl,50
     call gotoxy
     mwrite "move down"

     mov dh,9
     mov dl,20
     call gotoxy
     mwrite "d"
     mov dh,9
     mov dl,50
     call gotoxy
     mwrite "move right"

     mov dh,11
     mov dl,20
     call gotoxy
     mwrite "a"
     mov dh,11
     mov dl,50
     call gotoxy
     mwrite "move left"

     mov dh,13
     mov dl,20
     call gotoxy
     mwrite "p"
     mov dh,13
     mov dl,50
     call gotoxy
     mwrite "pause"

     mov dh,15
     mov dl,20
     call gotoxy
     mwrite "b"
     mov dh,15
     mov dl,50
     call gotoxy
     mwrite "go back"

     mov eax,red
     call settextcolor
     mov dh,18
     mov dl,27
     call gotoxy
     mwrite"|"
     mov dh,18
     mov dl,45
     call gotoxy
     mwrite"|"
     mov dh,17
     mov dl,27
     call gotoxy
     mwrite "___________________"
     mov dh,19
     mov dl,27
     call gotoxy
     mwrite "-------------------"

     mov eax,cyan+(black*16)
     call settextcolor

     mov dh,18
     mov dl,30
     call gotoxy
     mwrite "Instructions"

     mov dh,20
     mov dl,20
     call gotoxy
     mwrite "Your character:"
     mov dh,20
     mov dl,50
     call gotoxy
     mwrite "X"
     
     mov dh,22
     mov dl,20
     call gotoxy
     mwrite "Ghosts:"
     mov dh,22
     mov dl,50
     call gotoxy
     mwrite "A, B, C, D"

     mov dh,24
     mov dl,20
     call gotoxy
     mwrite "Fruits:"
     mov dh,24
     mov dl,50
     call gotoxy
     mwrite "@, #, $, %, ^, &, +, ~"

    

    lookforkey:
    mov eax,50
    call Delay  
    call readkey
    jz lookforkey

    cmp al,'b'
    jne lookforkey
    ret
    
InstructionScreen endp

;drawing manu
drawmenu proc uses ecx

 mov dl,60
    mov dh,5
    call gotoxy
    mov eax,lightRed +(black * 16)
    call settextcolor

    mwrite "--------------------"


    mov dl,60
    mov dh,7
    call gotoxy
    mov eax,lightRed +(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,60
    mov dh,6
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,79
    mov dh,6
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0

    

    mov dl,68
    mov dh,6
    call gotoxy
    cmp ecx,0
    jne norm1
    mov eax,yellow + (black * 16)
    jmp n1
    norm1:
    mov eax,magenta ;(black * 16)
    n1:
    call settextcolor
    mwrite "PLAY"





    mov dl,60
    mov dh,10
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,60
    mov dh,12
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,60
    mov dh,11
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,79
    mov dh,11
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0

    mov dl,64
    mov dh,11
    call gotoxy
    cmp ecx,1
    jne norm2
    mov eax,yellow
    jmp n2
    norm2:
    mov eax,magenta ;(black * 16)
    n2:
    call settextcolor
    mwrite "Instructions"





    mov dl,60
    mov dh,15
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,60
    mov dh,17
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,60
    mov dh,16
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,79
    mov dh,16
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "|",0

    mov dl,68
    mov dh,16
    call gotoxy
    cmp ecx,2
    jne norm3
    mov eax,yellow
    jmp n3
    norm3:
    mov eax,magenta ;(black * 16)
    n3:
    call settextcolor
    mwrite "EXIT"


    mov eax,yellow
    call settextcolor
    mov dl,30
    mov dh,20
    call gotoxy
    mwrite "__________________|      |____________________________________________"
     mov dl,30
    mov dh,21
    call gotoxy
    mwrite "     ,--.    ,--.          ,--.   ,--."
     mov dl,30
    mov dh,22
    call gotoxy
    mwrite "    |oo  | _  \  `.       | oo | |  oo|"
     mov dl,30
    mov dh,23
    call gotoxy
    mwrite "o  o|~~  |(_) /   ;       | ~~ | |  ~~|o  o  o  o  o  o  o  o  o  o  o"
     mov dl,30
    mov dh,24
    call gotoxy
    mwrite "    |/\/\|   '._,'        |/\/\| |/\/\|"
     mov dl,30
    mov dh,25
    call gotoxy
    mwrite "__________________        ____________________________________________"
     mov dl,30
    mov dh,26
    call gotoxy
    mwrite "                  |      |"
    ret
drawmenu endp


;window/ boundary of game
drawWindow proc
    mov al,level
    mov currentLevel,al
    mov eax,blue+(black*16)
    call settextcolor
    call clrscr
    mov dl,10
    mov dh,2
    call gotoxy
    ;storing in array simultaneuously
    l1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
        inc dl
    cmp dl,93
    jle l1

    call gotoxy
    l2:
    ;storing in array simultaneuously
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
        
    cmp dh,25
    jle l2

    
    call gotoxy
    l3:
    ;storing in array simultaneuously
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray

         mwrite "-"
         mov bl,1
         mov [esi+eax],bl
         dec dl
         call gotoxy
    cmp dl,11
    jge l3

      movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray

        mwrite "-"
         mov bl,1
         mov [esi+eax],bl


    call gotoxy
    l4:
    ;storing in array simultaneuously
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        dec dh
        call gotoxy
    cmp dh,2
    jge l4

    call drawmaze
   
    call setNoDotZone
    call setGhostLocation
    call drawDots
  ;  call drawarray
    call startgame
    mov al,level
    mov currentLevel,al
    cmp al,2
    je drawWindow
    cmp al,3
    je drawWindow
    cmp al,4    ;if lvl 3 completed
    je displayEndScreen
    ret
drawWindow endp

;maze with each level
drawmaze proc

    mov dl,19
    mov dh,4
    call gotoxy
    mov ecx,9
    l1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l1



    mov dl,34
    mov dh,4
    call gotoxy
    mov ecx,11
    l2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l2

    mov dl,52
    mov dh,3
    call gotoxy
    mov ecx,2
    l3:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l3

    mov dl,60
    mov dh,4
    call gotoxy
    mov ecx,11
    l4:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l4

    mov dl,77
    mov dh,4
    call gotoxy
    mov ecx,9
    l5:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l5


    mov dl,19
    mov dh,7
    call gotoxy
    mov ecx,9
    l6:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l6

    mov dl,44
    mov dh,7
    call gotoxy
    mov ecx,17
    l7_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l7_1

    mov dl,52
    mov dh,8
    call gotoxy
    mov ecx,3
    l7_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l7_2

    mov dl,77
    mov dh,7
    call gotoxy
    mov ecx,9
    l8:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l8


    mov dl,34
    mov dh,7
    call gotoxy
    mov ecx,5
    l9_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l9_1


     mov dl,35
    mov dh,9
    call gotoxy
    mov ecx,7
    l9_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l9_2


    mov dl,70
    mov dh,7
    call gotoxy
    mov ecx,5
    l10_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l10_1


    mov dl,63
    mov dh,9
    call gotoxy
    mov ecx,7
    l10_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l10_2

    mov dl,34
    mov dh,14
    call gotoxy
    mov ecx,3
    l11:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l11

    mov dl,34
    mov dh,19
    call gotoxy
    mov ecx,9
    l12:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l12

    mov dl,34
    mov dh,21
    call gotoxy
    mov ecx,3
    l13_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l13_1

    mov dl,19
    mov dh,24
    call gotoxy
    mov ecx,25
    l13_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l13_2


     mov dl,70
    mov dh,14
    call gotoxy
    mov ecx,3
    l14:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l14

    mov dl,61
    mov dh,19
    call gotoxy
    mov ecx,9
    l15:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l15

    mov dl,70
    mov dh,21
    call gotoxy
    mov ecx,3
    l16_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l16_1

    mov dl,60
    mov dh,24
    call gotoxy
    mov ecx,25
    l16_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l16_2


    mov dl,44
    mov dh,13
    call gotoxy
    mov ecx,7
    box1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop box1

    mov dl,54
    mov dh,13
    call gotoxy
    mov ecx,7
    box2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop box2



    mov dl,60
    mov dh,14
    call gotoxy

    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray

    mwrite "|"
    mov bl,1
    mov [esi+eax],bl


    mov dl,44
    mov dh,15
    call gotoxy
    mov ecx,17
    box3:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop box3

    mov dl,44
    mov dh,14
    call gotoxy

    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray

    mwrite "|"
    mov bl,1
    mov [esi+eax],bl


    mov dl,45
    mov dh,17
    call gotoxy
    mov ecx,15
    l17_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l17_1

    mov dl,52
    mov dh,18
    call gotoxy
    mov ecx,2
    l17_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l17_2


     mov dl,45
    mov dh,21
    call gotoxy
    mov ecx,15
    l18_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l18_1
    

    mov dl,52
    mov dh,22
    call gotoxy
    mov ecx,2
    l18_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l18_2

    mov al,level
    cmp al,2
    je draw2
    cmp al,3
    je draw3
    mov dl,19
    mov dh,10
    call gotoxy
    mov ecx,12
    l19_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l19_1

    mov dl,20
    mov dh,16
    call gotoxy
    mov ecx,8
    l19_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l19_2


    mov dl,85
    mov dh,10
    call gotoxy
    mov ecx,12
    l20_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        ;add eax,ecx

        mwrite "|"
        mov bl,1
        mov [esi+eax],bl
        call crlf
        inc dh
        call gotoxy
    loop l20_1

    mov dl,77
    mov dh,16
    call gotoxy
    mov ecx,8
    l20_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l20_2
    ret
    draw2:
       mov dl,19
       mov dh,5
       call gotoxy
       mov ecx,2
        l21:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l21

    ;level 2 maze
    mov dl,85
    mov dh,5
    call gotoxy
    mov ecx,2
    l22:
       movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l22

    mov dl,19
    mov dh,9
    call gotoxy
    mov ecx,8
    l23:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l23

    mov dl,19
    mov dh,10
    call gotoxy
    mov ecx,2
    l24:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l24

    mov dl,19
    mov dh,12
    call gotoxy
    mov ecx,8
    l25:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l25

    mov dl,26
    mov dh,13
    call gotoxy
    mov ecx,2
    l26:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l26

    mov dl,19
    mov dh,15
    call gotoxy
    mov ecx,8
    l27:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l27

    mov dl,19
    mov dh,16
    call gotoxy
    mov ecx,2
    l28:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l28

    mov dl,19
    mov dh,18
    call gotoxy
    mov ecx,8
    l29:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l29

    mov dl,26
    mov dh,19
    call gotoxy
    mov ecx,2
    l30:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l30

    mov dl,19
    mov dh,21
    call gotoxy
    mov ecx,8
    l31:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l31



    mov dl,77
    mov dh,9
    call gotoxy
    mov ecx,8
    l32:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l32

    mov dl,85
    mov dh,10
    call gotoxy
    mov ecx,2
    l33:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l33

    mov dl,77
    mov dh,12
    call gotoxy
    mov ecx,8
    l34:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l34

    mov dl,77
    mov dh,13
    call gotoxy
    mov ecx,2
    l35:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l35

    mov dl,77
    mov dh,15
    call gotoxy
    mov ecx,8
    l36:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l36

    mov dl,85
    mov dh,16
    call gotoxy
    mov ecx,2
    l37:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l37

    mov dl,77
    mov dh,18
    call gotoxy
    mov ecx,8
    l38:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l38

    mov dl,77
    mov dh,19
    call gotoxy
    mov ecx,2
    l39:
        movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l39

    mov dl,77
    mov dh,21
    call gotoxy
    mov ecx,8
    l40:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l40

    mov dl,11
    mov dh,13
    call gotoxy
    mov ecx,5
    l41:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l41

    mov dl,89
    mov dh,13
    call gotoxy
    mov ecx,5
    l42:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l42
    ret

    ;level3 maze
    draw3:
        mov dl,17
       mov dh,10
       call gotoxy
       mov ecx,12
        l43_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l43_1

     mov dl,19
       mov dh,12
       call gotoxy
       mov ecx,10
        l43_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l43_2

     mov dl,27
       mov dh,12
       call gotoxy
       mov ecx,10
        l43_3:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l43_3

     mov dl,29
       mov dh,10
       call gotoxy
       mov ecx,12
        l43_4:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l43_4

    mov dl,17
    mov dh,9
    call gotoxy
    mov ecx,13
    l43_5:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l43_5

    mov dl,19
    mov dh,11
    call gotoxy
    mov ecx,9
    l43_6:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l43_6

       mov dl,77
       mov dh,10
       call gotoxy
       mov ecx,12
        l44_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l44_1

     mov dl,79
       mov dh,12
       call gotoxy
       mov ecx,10
        l44_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l44_2

     mov dl,87
       mov dh,12
       call gotoxy
       mov ecx,10
        l44_3:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l44_3

     mov dl,89
       mov dh,10
       call gotoxy
       mov ecx,12
        l44_4:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l44_4

    mov dl,77
    mov dh,9
    call gotoxy
    mov ecx,13
    l44_5:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l44_5

    mov dl,79
    mov dh,11
    call gotoxy
    mov ecx,9
    l44_6:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l44_6

    mov dl,30
    mov dh,11
    call gotoxy
    mov ecx,3
    l45_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l45_1


    mov dl,31
    mov dh,14
    call gotoxy
    mov ecx,3
    l45_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l45_2


    mov dl,30
    mov dh,16
    call gotoxy
    mov ecx,3
    l45_3:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l45_3

    mov dl,31
    mov dh,19
    call gotoxy
    mov ecx,3
    l45_4:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l45_4



    mov dl,72
    mov dh,11
    call gotoxy
    mov ecx,5
    l46_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l46_1


    mov dl,71
    mov dh,14
    call gotoxy
    mov ecx,5
    l46_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l46_2


    mov dl,72
    mov dh,16
    call gotoxy
    mov ecx,5
    l46_3:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l46_3

    mov dl,70
    mov dh,19
    call gotoxy
    mov ecx,6
    l46_4:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l46_4

    mov dl,11
    mov dh,11
    call gotoxy
    mov ecx,3
    l47_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l47_1

    mov dl,11
    mov dh,16
    call gotoxy
    mov ecx,3
    l47_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l47_2

    mov dl,91
    mov dh,11
    call gotoxy
    mov ecx,3
    l48_1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l48_1

    mov dl,91
    mov dh,16
    call gotoxy
    mov ecx,3
    l48_2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite "-"
        mov bl,1
        mov [esi+eax],bl
    loop l48_2

    mov dl,44
       mov dh,3
       call gotoxy
       mov ecx,2
        l49_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l49_1

    mov dl,60
       mov dh,3
       call gotoxy
       mov ecx,2
        l49_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l49_2

    mov dl,44
       mov dh,24
       call gotoxy
       mov ecx,2
        l50_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l50_1

    mov dl,60
       mov dh,24
       call gotoxy
       mov ecx,2
        l50_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l50_2

    mov dl,44
       mov dh,8
       call gotoxy
       mov ecx,2
        l51_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l51_1

    mov dl,60
       mov dh,8
       call gotoxy
       mov ecx,2
        l51_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l51_2

    mov dl,45
       mov dh,18
       call gotoxy
       mov ecx,2
        l52_1:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l52_1

    mov dl,59
       mov dh,18
       call gotoxy
       mov ecx,2
        l52_2:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l52_2


       mov dl,19
       mov dh,5
       call gotoxy
       mov ecx,2
        l53:
            movzx eax,dh
            sub eax,2
            mov bl,85
            mul bl
            movzx ebx,dl
            sub ebx,10
            add eax,ebx
            mov esi, offset mazeArray

            mwrite "|"
            mov bl,1
            mov [esi+eax],bl
            call crlf
            inc dh
            call gotoxy
    loop l53

    mov dl,85
    mov dh,5
    call gotoxy
    mov ecx,2
    l54:
       movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite "|"
       mov bl,1
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l54

    mov dl,52
    mov dh,3
    call gotoxy
    mov ecx,2
    l55:
    movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite " "
       mov bl,0
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l55

    mov dl,10
    mov dh,12
    call gotoxy
    mov ecx,4
    l56:
    movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite " "
       mov bl,6
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l56

    mov dl,94
    mov dh,12
    call gotoxy
    mov ecx,4
    l57:
    movzx eax,dh
       sub eax,2
       mov bl,85
       mul bl
       movzx ebx,dl
       sub ebx,10
       add eax,ebx
       mov esi, offset mazeArray

       mwrite " "
       mov bl,6
       mov [esi+eax],bl
       call crlf
       inc dh
       call gotoxy
    loop l57

    mov dl,45
    mov dh,2
    call gotoxy
    mov ecx,15
    l58:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite " "
        mov bl,6
        mov [esi+eax],bl
    loop l58

    mov dl,45
    mov dh,26
    call gotoxy
    mov ecx,15
    l59:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,11
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mwrite " "
        mov bl,6
        mov [esi+eax],bl
    loop l59
    ret
drawmaze endp

; drawing dots at 0 in array
drawDots proc

    mov ecx,25
    mov esi,offset mazeArray
    mov temp1,2
    l1:
        mov count,ecx
        mov ecx,85
        mov temp2,9
        l2:
            mov bl,0
            inc temp2
            cmp [esi],bl
            je drawDot
            inc esi
            loop l2
        mov ecx,count
        inc temp1
        loop l1
        cmp ecx,0
        je quit
        drawDot:
            mov dl,temp2
            mov dh,temp1
            call gotoxy
            mov eax,lightgray+(black*16)
            call settextcolor
            mwrite "."
            inc esi
            loop l2
        quit:
           ret



drawDots endp

startgame proc
;displaying all entities
call drawplayer
call drawGhost1
call drawGhost2
call drawGhost3
call drawGhost4
;call drawarray

movzx eax,level
sub time,eax


mov dh,4
mov dl,96
call gotoxy
mwrite "Level: "
movzx eax, level
call writeint

mov dh,6
mov dl,96
call gotoxy
mov edx,offset username
call writestring
mov num,0
gameloop:


call drawscore
call drawlives
call checkLevel
mov bl,level
cmp bl,currentLevel
jg quit


;looking for key
    lookforkey:
    mov eax,30
    call delay
    ;calling for movement
    call G1Movement
    call G2Movement
    call G3Movement
    call G4Movement
    call drawfruits
    call readkey
    jz lookforkey

    movzx eax,al
    ;movement
    cmp eax,119
    je moveUp

    cmp eax,115
    je moveDown

    cmp eax,97
    je moveLeft

    cmp eax,100
    je moveRight

    ;pausing game
    cmp eax,112
    je callPausescreen

    jmp gameloop



    ;moving with checking collisions
    moveUp:
            dec yPos
            push offset [num]
            call checkCollision
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont1
                inc yPos
                mov num,0 
                jmp gameloop
            cont1:
            call addscore
            inc yPos
            call UpdatePlayer
            dec yPos
            call DrawPlayer
            jmp gameLoop

        moveDown:
            inc yPos
            push offset [num]
            call checkCollision
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont2
                dec yPos
                mov num,0
                jmp gameLoop
            cont2:
            call addscore
            dec yPos
            call UpdatePlayer
            inc yPos
            call DrawPlayer

            jmp gameLoop

        moveLeft:
            dec xPos
            push offset [num]
            call checkCollision
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont3
                inc xPos
                mov num,0
                jmp gameLoop
            cont3:
            call addscore
            inc xPos
            call UpdatePlayer
            dec xPos
            call DrawPlayer
            jmp gameLoop

        moveRight:
            inc xPos
            push offset [num]
            call checkCollision
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont4
                dec xPos
                mov num,0
                jmp gameLoop
            cont4:
            call addscore
            dec xPos
            call UpdatePlayer
            inc xPos
            call DrawPlayer
            jmp gameLoop

            ;calling for pause scrren
    callPausescreen:
    call pausescreen

    jmp gameLoop

quit:
    ret
startgame endp

;pause screen
pausescreen proc

mov ecx,0
    menu:
    call clrscr
    call pausemenu

    lookforkey:
    mov  eax,50
    call Delay  
    call readkey
    jz lookforkey

    movzx eax,al

    cmp eax,119
    je movup

    cmp eax,115
    je movdown

    cmp eax,13
    je checknext
    jmp menu

    movup:
        cmp ecx,0
        jle menu

        dec ecx
        jmp menu
    movdown:
        cmp ecx,2
        jge menu

        inc ecx
        jmp menu

    checknext:
        cmp ecx,0
        je calldrawWindow

        cmp ecx,1
        je callInstructionScreen

        cmp ecx,2
        je quit

        calldrawWindow:
        call drawWindow

        callInstructionScreen:
        call instructionscreen
        jmp menu
        

    
    quit:
      exit

pausescreen endp

pausemenu proc
mov dl,50
    mov dh,5
    call gotoxy
    mov eax,lightRed +(black * 16)
    call settextcolor

    mwrite "--------------------"


    mov dl,50
    mov dh,7
    call gotoxy
    mov eax,lightRed +(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,50
    mov dh,6
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,69
    mov dh,6
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0

    

    mov dl,58
    mov dh,6
    call gotoxy
    cmp ecx,0
    jne norm1
    mov eax,yellow + (black * 16)
    jmp n1
    norm1:
    mov eax,magenta ;(black * 16)
    n1:
    call settextcolor
    mwrite "RESUME"


    mov dl,50
    mov dh,10
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,50
    mov dh,12
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,50
    mov dh,11
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,69
    mov dh,11
    call gotoxy
    mov eax,lightRed ;(black * 16)
    call settextcolor
    mwrite "|",0

    mov dl,54
    mov dh,11
    call gotoxy
    cmp ecx,1
    jne norm2
    mov eax,yellow
    jmp n2
    norm2:
    mov eax,magenta ;(black * 16)
    n2:
    call settextcolor
    mwrite "Instructions"


    mov dl,50
    mov dh,15
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,50
    mov dh,17
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "--------------------"


    mov dl,50
    mov dh,16
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "|",0


    mov dl,69
    mov dh,16
    call gotoxy
    mov eax,lightred ;(black * 16)
    call settextcolor
    mwrite "|",0

    mov dl,58
    mov dh,16
    call gotoxy
    cmp ecx,2
    jne norm3
    mov eax,yellow
    jmp n3
    norm3:
    mov eax,magenta ;(black * 16)
    n3:
    call settextcolor
    mwrite "Exit"

    ret
pausemenu endp

scoretostring proc

    mov eax,score
    mov edx,eax
    l1:
    mov bl,10
    div bl
    inc sizeofstr
    movzx eax,al
    cmp eax,0
    jne l1

    mov eax,edx
    mov esi,offset scorestring
    movzx ecx,sizeofstr
    l2:
        mov bl,10
        div bl
        mov bl,'0'
        add bl,ah
        mov [esi+ecx-1],bl
        mov eax,edx
        mov bl,10
        div bl
        movzx eax,al
        mov edx,eax
    loop l2

    ret
scoretostring endp

lvltostring proc
    mov esi,offset lvlstring
        mov bl,'0'
        add bl,level
        mov [esi],bl

    ret
lvltostring endp

;drawing player
drawplayer PROC
;storing in array simultaneuously
    mov eax,yellow ;(blue*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mwrite "X"
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,4
    mov[esi+eax],bl
    ret
drawplayer ENDP

;updating player
UpdatePlayer PROC
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mwrite " "
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,[esi+eax]
    cmp bl,0
    je store1
    cmp bl,-1
    je store1
    cmp bl,2
    je store1
    cmp bl,3
    je store1
    ;storing in array simultaneuously
    mov bl,6
    mov[esi+eax],bl
    jmp quit
    store1:
    mov bl,-1
    mov[esi+eax],bl
    quit:
    ret
UpdatePlayer ENDP

;checking collision pf player
checkCollision proc 
    push ebp
    mov ebp,esp
    movzx eax, yPos    ; Row index
    movzx ebx, xPos    ; Column index
    sub eax,2
    mov ecx,85
    mul ecx
    sub ebx,10
    add eax,ebx
    mov ebx,eax
    mov esi,offset mazeArray
    mov al, [esi + eax]
    mov ah,0
    cmp al, 0            ; Check if the cell contains a wall (1)
    je NOWALL    ; Jump if there's a collision
    
    cmp al,3    ;3 no dot zone
    je nowall
    cmp al,5    ;5 fruits
    je nowall
    cmp al,6    ;6 teleportaion point
    je callteleport
    cmp al,-1   ;-1 already collected dots or path
    je nowall
    mov num,1   ;1 wall detected
    mov edi,offset [num]
    mov [ebp+8],edi
    jmp nowall
    callteleport:
    call teleport
    NOWALL:
    pop ebp
    ret

checkCollision endp

;teleporting player in lvl3
teleport proc
    cmp ypos,12
    jl checkup
    cmp ypos,15
    jg checkdown
    cmp xpos,10
    jne checkright

    inc xpos
    call updateplayer
    mov xpos,93
    jmp quit

    checkright:
    cmp xpos,94
    jne quit

    dec xpos
    call updateplayer
    mov xpos,11
    jmp quit

    checkup:
    cmp xpos,45
    jl quit
    cmp xpos,60
    jg quit
    cmp ypos,2
    jne checkdown
    inc ypos
    call updateplayer
    mov ypos,25
    jmp quit

    checkdown:
    cmp xpos,45
    jl quit
    cmp xpos,60
    jg quit
    cmp ypos,26
    jne quit
    dec ypos
    call updateplayer
    mov ypos,3
    jmp quit

    quit:
    ret
teleport endp

;for score
drawscore proc

    mov eax,lightgreen (black * 16)
        call SetTextColor

        ; draw score:
        mov dl,96
        mov dh,7
        call Gotoxy
        mwrite "Score: "
        mov dl,96
        mov dh,8
        call Gotoxy
        mov eax,score
        call WriteInt

        
drawscore endp

;for lives
drawlives proc
    

    mov eax,lightgreen (black * 16)
        call SetTextColor
; draw lives:
        mov dl,96
        mov dh,10
        call Gotoxy
        mwrite "Lives: "
        mov dl,96
        mov dh,11
        call gotoxy
        mov eax,red (black * 16)
        call SetTextColor
        movzx ecx,lives
        d1:
            mwrite "(\/)"
        loop d1
        mov dl,96
        mov dh,12
        call gotoxy
        movzx ecx,lives
        d2:
            mwrite " \/ "
        loop d2
drawlives endp

;adding score
addscore proc
    mov dl,xpos
    mov dh,ypos
    movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        mov bl,[esi+eax]
        cmp bl,0
        je sum
        cmp bl,5
        je bonus
        ret
        sum:
        mov eax,5
        add score,eax
        ret
        bonus:
        mov eax,10
        add score,eax
        ret
addscore endp

;fruit logic
drawfruits proc
    mov al,level
    cmp al,2
    jl quit
    
    cmp fruitduration,0
    jne skip
    cmp fruitcount,200
    je callgeneratefruit

    cmp fruitcount,1
    jl skip2
    dec fruitcount
    jmp quit
    skip2:
        mov dl,52
        mov dh,16
        call Gotoxy
        mwrite " "
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        mov bl,-1
        mov[esi+eax],bl
        mov fruitduration,200
        dec fruitcount
        jmp quit
    callgeneratefruit:
    dec fruitcount
    call generatefruit
    jmp quit
 
    jmp quit
    skip:
    mov fruitcount,200
    dec fruitduration
    quit:
    ret
drawfruits endp
;generating random fruits
generatefruit proc
 mov dl,52
    mov dh,16
    call gotoxy

    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,5
    mov [esi+eax],bl
    
    call randomize
    mov eax,8
    call randomrange
    cmp eax,0
    je drawf1

    cmp eax,1
    je drawf2

    cmp eax,2
    je drawf3

    cmp eax,3
    je drawf4

    cmp eax,4
    je drawf5

    cmp eax,5
    je drawf6

    cmp eax,6
    je drawf7

    cmp eax,7
    je drawf8

    drawf1:
        mwrite "@"
        jmp quit
    drawf2:
        mwrite "#"
        jmp quit
    drawf3:
        mwrite "$"
        jmp quit
    drawf4:
        mwrite "%"
        jmp quit
    drawf5:
        mwrite "^"
        jmp quit
    drawf6:
        mwrite "&"
        jmp quit
    drawf7:
        mwrite "+"
        jmp quit
    drawf8:
        mwrite "~"
        jmp quit
    quit:
    ret
generatefruit endp
;ghost location/home
setGhostLocation proc
    mov dl,44
    mov dh,14
    mov ecx,15
    l1:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx

        mov bl,2
        mov [esi+eax],bl
    loop l1

    mov dl,50
    mov dh,13
    mov ecx,3
    l2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx
 
        mov bl,2
        mov [esi+eax],bl
    loop l2
        ret;
setGhostLocation endp

;no dot zone. dots will not spawn here
setNoDotZone proc
  
  mov ecx,9
  mov dh,9
  l1:
    mov temploop,ecx
    mov dl,34
    
    mov ecx,35
    l2:
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx
        mov bl,[esi+eax]
        cmp bl,1
        je notSetting

        mov bl,3
        mov [esi+eax],bl
        notSetting:
    loop l2
    inc dh
    mov ecx,temploop
   loop l1

   mov ecx,23
   mov dh,3
   l3:
     mov temploop,ecx
     mov dl,10
         mov linecount,0
    
    mov ecx,82
    l4:
        
        cmp linecount,4
        je notsetting2
        inc linecount
        
        movzx eax,dh
        sub eax,2
        mov bl,85
        mul bl
        movzx ebx,dl
        sub ebx,10
        add eax,ebx
        mov esi, offset mazeArray
        add eax,ecx
        mov bl,[esi+eax]
        cmp bl,1
        je again

        mov bl,3
        mov [esi+eax],bl
        jmp again
        notSetting2:
           mov linecount,0
        again:

    loop l4
    mov linecount,0
    inc dh
    mov ecx,temploop
   loop l3

    

    
    ret
setNoDotZone endp
;drawing ghosts
drawGhost1 proc
    mov dl,G1XPOS
    mov dh,G1YPOS
    call gotoxy
    mov eax, red+(black*16)
    call settextcolor
    mwrite "A"
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,[esi+eax]
    mov previousElement1,bl
    mov bl,2
    mov[esi+eax],bl
    ret
drawGhost1 endp

drawGhost2 proc
    cmp level,2
    jl quit
    mov dl,G2XPOS
    mov dh,G2YPOS
    call gotoxy
    mov eax, lightcyan+(black*16)
    call settextcolor
    mwrite "B"
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,[esi+eax]
    mov previousElement2,bl
    mov bl,2
    mov[esi+eax],bl
    quit:
    ret
drawGhost2 endp

drawGhost3 proc
    cmp level,3
    jl quit

    draw:
    mov dl,G3XPOS
    mov dh,G3YPOS
    call gotoxy
    mov eax, lightmagenta+(black*16)
    call settextcolor
    mwrite "C"
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,[esi+eax]
    mov previousElement3,bl
    mov bl,2
    mov[esi+eax],bl
    quit:
   ret
drawGhost3 endp

drawGhost4 proc
    cmp level,3
    jl quit

 mov dl,G4XPOS
    mov dh,G4YPOS
    call gotoxy
    mov eax, lightgreen+(black*16)
    call settextcolor
    mwrite "D"
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,[esi+eax]
    mov previousElement4,bl
    mov bl,2
    mov[esi+eax],bl
    quit:
    ret
drawGhost4 endp

;ghosts movement similar to player but random
G1Movement proc
call randomize
mov eax,time
cmp timeloop1,eax
jl quit
mov timeloop1,0
mov num,0
    mov bl,GM1loop
    cmp bl,0
    jne skip

    mov al,5
    mov GM1loop,al
    mov eax,4
    call randomrange
    add eax,1
    mov randnum,al
    cmp al,1
    je moveup

    cmp al,2
    je moveright

    cmp al,3
    je movedown

    cmp al,4
    je moveleft

    skip:
    dec GM1loop
    mov al,currentcount1
    cmp al,1
    je moveup

    cmp al,2
    je moveright

    cmp al,3
    je movedown

    cmp al,4
    je moveleft


     moveUp:
            mov currentcount1,al
            dec G1yPos
            push offset [num]
            call checkCollisionG1
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont1
                inc G1yPos
                mov num,0 
                jmp quit
            cont1:
            inc G1yPos
            call UpdateGhost1
            dec G1yPos
            call DrawGhost1
            jmp quit

        moveDown:
            mov currentcount1,al
            inc G1yPos
            push offset [num]
            call checkCollisionG1
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont2
                dec G1yPos
                mov num,0
                jmp quit
            cont2:
            dec G1yPos
            call UpdateGhost1
            inc G1yPos
            call DrawGhost1
            jmp quit

        moveLeft:
            mov currentcount1,al
            dec G1xPos
            push offset [num]
            call checkCollisionG1
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont3
                inc G1xPos
                mov num,0
                jmp quit
            cont3:
            inc G1xPos
            call UpdateGhost1
            dec G1xPos
            call DrawGhost1
            jmp quit

        moveRight:
            mov currentcount1,al
            inc G1xPos
            push offset [num]
            call checkCollisionG1
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont4
                dec G1xPos
                mov num,0
               jmp quit
            cont4:
            dec G1xPos
            call UpdateGhost1
            inc G1xPos
            call DrawGhost1
            jmp quit

quit:
inc timeloop1
ret
G1Movement endp 

UpdateGhost1 proc
    mov dl,G1xPos
    mov dh,G1yPos
    call Gotoxy
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,previousElement1
    cmp dl,10
    je store6
    cmp dl,95
    je store6
    cmp dh,2
    je store6
    cmp dh,26
    je store6
    cmp bl,0
    je printdot
    cmp bl,-1
    je store1
    cmp bl,2
    je store1
    cmp bl,3
    je store1

    store6:
    mov bl,6
    mov[esi+eax],bl
    mwrite " "
    jmp quit
    store1:
    mwrite " "
    mov bl,-1
    mov [esi+eax],bl
    jmp quit
    printdot:
        mov bl,0
        mov [esi+eax],bl
        mov eax,lightgray
        call settextcolor
        mwrite "."
    quit:
    ret

UpdateGhost1 endp

checkCollisionG1 proc
    push ebp
    mov ebp,esp
    movzx eax, G1yPos    ; Row index
    movzx ebx, G1xPos    ; Column index
    sub eax,2
    mov ecx,85
    mul ecx
    sub ebx,10
    add eax,ebx
    mov ebx,eax
    mov esi,offset mazeArray
    mov al, [esi + eax]
    mov ah,0
;3 no dot zone
;5 fruits
;6 teleportaion point
;-1 already collected dots or path
 ;1 wall detected
    cmp al, 0            
    je quit    
    cmp al,3
    je quit
    cmp al,-1
    je quit
    cmp al,6
    je callG1teleport
    cmp al,4
    je callendlife
    mov num,1
    mov edi,offset [num]
    mov [ebp+8],edi
    jmp quit

    callG1teleport:
        call teleportG1
        jmp quit
    callendlife:
    call endlife
    quit:
    pop ebp
    ret

checkCollisionG1 endp


;teleporting ghost1
teleportG1 proc
    cmp G1ypos,12
    jl checkup
    cmp G1ypos,15
    jg checkdown
    cmp G1xpos,10
    jne checkright

    inc G1xpos
    call UpdateGhost1
    mov G1xpos,93
    jmp quit

    checkright:
    cmp G1xpos,94
    jne quit

    dec G1xpos
    call UpdateGhost1
    mov G1xpos,11
    jmp quit

    checkup:
    cmp G1xpos,45
    jl quit
    cmp G1xpos,60
    jg quit
    cmp G1ypos,2
    jne checkdown
    inc G1ypos
    call UpdateGhost1
    mov G1ypos,25
    jmp quit

    checkdown:
    cmp G1xpos,45
    jl quit
    cmp G1xpos,60
    jg quit
    cmp G1ypos,26
    jne quit
    dec G1ypos
    call UpdateGhost1
    mov G1ypos,3
    jmp quit

    quit:
    ret
teleportG1 endp


G2Movement proc
cmp level,2
jl quit
mov eax,time
cmp timeloop2,eax
jl quit
mov timeloop2,0
call randomize
mov num,0
    mov bl,GM2loop
    cmp bl,0
    jne skip

    mov al,5
    mov GM2loop,al
    mov eax,4
    call randomrange
    add eax,1
    mov randnum,al
    cmp al,1
    je movedown

    cmp al,2
    je moveleft

    cmp al,3
    je movedown

    cmp al,4
    je moveright

    skip:
    dec GM2loop
    mov al,currentcount2
    cmp al,1
    je movedown

    cmp al,2
    je moveleft

    cmp al,3
    je movedown

    cmp al,4
    je moveright


     moveUp:
            mov currentcount2,al
            dec G2yPos
            push offset [num]
            call checkCollisionG2
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont1
                inc G2yPos
                mov num,0 
                jmp quit
            cont1:
            inc G2yPos
            call UpdateGhost2
            dec G2yPos
            call DrawGhost2
            jmp quit

        moveDown:
            mov currentcount2,al
            inc G2yPos
            push offset [num]
            call checkCollisionG2
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont2
                dec G2yPos
                mov num,0
                jmp quit
            cont2:
            dec G2yPos
            call UpdateGhost2
            inc G2yPos
            call DrawGhost2
            jmp quit

        moveLeft:
            mov currentcount2,al
            dec G2xPos
            push offset [num]
            call checkCollisionG2
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont3
                inc G2xPos
                mov num,0
                jmp quit
            cont3:
            inc G2xPos
            call UpdateGhost2
            dec G2xPos
            call DrawGhost2
            jmp quit

        moveRight:
            mov currentcount2,al
            inc G2xPos
            push offset [num]
            call checkCollisionG2
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont4
                dec G2xPos
                mov num,0
               jmp quit
            cont4:
            dec G2xPos
            call UpdateGhost2
            inc G2xPos
            call DrawGhost2
            jmp quit

quit:
inc timeloop2
ret
G2Movement endp 

UpdateGhost2 proc
    mov dl,G2xPos
    mov dh,G2yPos
    call Gotoxy
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,previousElement2
    cmp dl,10
    je store6
    cmp dl,95
    je store6
    cmp dh,2
    je store6
    cmp dh,26
    je store6
    cmp bl,0
    je printdot
    cmp bl,-1
    je store1
    cmp bl,2
    je store1
    cmp bl,3
    je store1

    store6:
    mov bl,6
    mov[esi+eax],bl
    mwrite " "
    jmp quit
    store1:
    mwrite " "
    mov bl,-1
    mov [esi+eax],bl
    jmp quit
    printdot:
        mov bl,0
        mov [esi+eax],bl
        mov eax,lightgray
        call settextcolor
        mwrite "."
    quit:
    ret

UpdateGhost2 endp

checkCollisionG2 proc
    push ebp
    mov ebp,esp
    movzx eax, G2yPos    ; Row index
    movzx ebx, G2xPos    ; Column index
    sub eax,2
    mov ecx,85
    mul ecx
    sub ebx,10
    add eax,ebx
    mov ebx,eax
    mov esi,offset mazeArray
    mov al, [esi + eax]
    mov ah,0
;3 no dot zone
;5 fruits
;6 teleportaion point
;-1 already collected dots or path
 ;1 wall detected
    cmp al, 0            
    je quit    
    cmp al,3
    je quit
    cmp al,-1
    je quit
    cmp al,6
    je callG2teleport
    cmp al,4
    je callendlife
    mov num,1
    mov edi,offset [num]
    mov [ebp+8],edi
    jmp quit

    callG2teleport:
        call teleportG2
        jmp quit
    callendlife:
    call endlife
    quit:
    pop ebp
    ret

checkCollisionG2 endp

teleportG2 proc
    cmp G2ypos,12
    jl checkup
    cmp G2ypos,15
    jg checkdown
    cmp G2xpos,10
    jne checkright

    inc G2xpos
    call UpdateGhost2
    mov G2xpos,93
    jmp quit

    checkright:
    cmp G2xpos,94
    jne quit

    dec G2xpos
    call UpdateGhost2
    mov G2xpos,11
    jmp quit

    checkup:
    cmp G2xpos,45
    jl quit
    cmp G2xpos,60
    jg quit
    cmp G2ypos,2
    jne checkdown
    inc G2ypos
    call UpdateGhost2
    mov G2ypos,25
    jmp quit

    checkdown:
    cmp G2xpos,45
    jl quit
    cmp G2xpos,60
    jg quit
    cmp G2ypos,26
    jne quit
    dec G2ypos
    call UpdateGhost2
    mov G2ypos,3
    jmp quit

    quit:
    ret
teleportG2 endp

G3Movement proc
cmp level,3
jl quit
mov eax,time
cmp timeloop3,eax
jl quit
mov timeloop3,0
call randomize
mov num,0
    mov bl,GM3loop
    cmp bl,0
    jne skip

    mov al,5
    mov GM3loop,al
    mov eax,4
    call randomrange
    add eax,1
    mov randnum,al
    cmp al,1
    je moveright

    cmp al,2
    je moveleft

    cmp al,3
    je movedown

    cmp al,4
    je moveup

    skip:
    dec GM3loop
    mov al,currentcount3
    cmp al,1
    je moveright

    cmp al,2
    je moveleft

    cmp al,3
    je movedown

    cmp al,4
    je moveup


     moveUp:
            mov currentcount3,al
            dec G3yPos
            push offset [num]
            call checkCollisionG3
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont1
                inc G3yPos
                mov num,0 
                jmp quit
            cont1:
            inc G3yPos
            call UpdateGhost3
            dec G3yPos
            call DrawGhost3
            jmp quit

        moveDown:
            mov currentcount3,al
            inc G3yPos
            push offset [num]
            call checkCollisionG3
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont2
                dec G3yPos
                mov num,0
                jmp quit
            cont2:
            dec G3yPos
            call UpdateGhost3
            inc G3yPos
            call DrawGhost3
            jmp quit

        moveLeft:
            mov currentcount3,al
            dec G3xPos
            push offset [num]
            call checkCollisionG3
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont3
                inc G3xPos
                mov num,0
                jmp quit
            cont3:
            inc G3xPos
            call UpdateGhost3
            dec G3xPos
            call DrawGhost3
            jmp quit

        moveRight:
            mov currentcount3,al
            inc G3xPos
            push offset [num]
            call checkCollisionG3
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont4
                dec G3xPos
                mov num,0
               jmp quit
            cont4:
            dec G3xPos
            call UpdateGhost3
            inc G3xPos
            call DrawGhost3
            jmp quit

quit:
inc timeloop3
ret
G3Movement endp 

UpdateGhost3 proc
    mov dl,G3xPos
    mov dh,G3yPos
    call Gotoxy
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,previousElement3
    cmp dl,10
    je store6
    cmp dl,95
    je store6
    cmp dh,2
    je store6
    cmp dh,26
    je store6
    cmp bl,0
    je printdot
    cmp bl,-1
    je store1
    cmp bl,2
    je store1
    cmp bl,3
    je store1

    store6:
    mov bl,6
    mov[esi+eax],bl
    mwrite " "
    jmp quit
    store1:
    mwrite " "
    mov bl,-1
    mov [esi+eax],bl
    jmp quit
    printdot:
        mov bl,0
        mov [esi+eax],bl
        mov eax,lightgray
        call settextcolor
        mwrite "."
    quit:
    ret

UpdateGhost3 endp

checkCollisionG3 proc
    push ebp
    mov ebp,esp
    movzx eax, G3yPos    ; Row index
    movzx ebx, G3xPos    ; Column index
    sub eax,2
    mov ecx,85
    mul ecx
    sub ebx,10
    add eax,ebx
    mov ebx,eax
    mov esi,offset mazeArray
    mov al, [esi + eax]
    mov ah,0
;3 no dot zone
;5 fruits
;6 teleportaion point
;-1 already collected dots or path
 ;1 wall detected
    cmp al, 0            
    je quit    
    cmp al,3
    je quit
    cmp al,-1
    je quit
    cmp al,6
    je callG3teleport
    cmp al,4
    je callendlife
    mov num,1
    mov edi,offset [num]
    mov [ebp+8],edi
    jmp quit

    callG3teleport:
        call teleportG3
        jmp quit
    callendlife:
    call endlife
    quit:
    pop ebp
    ret

checkCollisionG3 endp

teleportG3 proc
    cmp G3ypos,12
    jl checkup
    cmp G3ypos,15
    jg checkdown
    cmp G3xpos,10
    jne checkright

    inc G3xpos
    call UpdateGhost3
    mov G3xpos,93
    jmp quit

    checkright:
    cmp G3xpos,94
    jne quit

    dec G3xpos
    call UpdateGhost3
    mov G3xpos,11
    jmp quit

    checkup:
    cmp G3xpos,45
    jl quit
    cmp G3xpos,60
    jg quit
    cmp G3ypos,2
    jne checkdown
    inc G3ypos
    call UpdateGhost3
    mov G3ypos,25
    jmp quit

    checkdown:
    cmp G3xpos,45
    jl quit
    cmp G3xpos,60
    jg quit
    cmp G3ypos,26
    jne quit
    dec G3ypos
    call UpdateGhost3
    mov G3ypos,3
    jmp quit

    quit:
    ret
teleportG3 endp

G4Movement proc
cmp level,3
jl quit
mov eax,time
cmp timeloop4,eax
jl quit
mov timeloop4,0
call randomize
mov num,0
    mov bl,GM4loop
    cmp bl,0
    jne skip

    mov al,5
    mov GM4loop,al
    mov eax,4
    call randomrange
    add eax,1
    mov randnum,al
    cmp al,1
    je moveleft

    cmp al,2
    je movedown

    cmp al,3
    je moveright

    cmp al,4
    je moveup

    skip:
    dec GM4loop
    mov al,currentcount4
    cmp al,1
    je moveleft

    cmp al,2
    je movedown

    cmp al,3
    je moveright

    cmp al,4
    je moveup


     moveUp:
            mov currentcount4,al
            dec G4yPos
            push offset [num]
            call checkCollisionG4
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont1
                inc G4yPos
                mov num,0 
                jmp quit
            cont1:
            inc G4yPos
            call UpdateGhost4
            dec G4yPos
            call DrawGhost4
            jmp quit

        moveDown:
            mov currentcount4,al
            inc G4yPos
            push offset [num]
            call checkCollisionG4
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont2
                dec G4yPos
                mov num,0
                jmp quit
            cont2:
            dec G4yPos
            call UpdateGhost4
            inc G4yPos
            call DrawGhost4
            jmp quit

        moveLeft:
            mov currentcount4,al
            dec G4xPos
            push offset [num]
            call checkCollisionG4
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont3
                inc G4xPos
                mov num,0
                jmp quit
            cont3:
            inc G4xPos
            call UpdateGhost4
            dec G4xPos
            call DrawGhost4
            jmp quit

        moveRight:
            mov currentcount4,al
            inc G4xPos
            push offset [num]
            call checkCollisionG4
            pop esi
            mov ebx,[esi]
            cmp bl,1
            jne cont4
                dec G4xPos
                mov num,0
               jmp quit
            cont4:
            dec G4xPos
            call UpdateGhost4
            inc G4xPos
            call DrawGhost4
            jmp quit

quit:
inc timeloop4
ret
G4Movement endp 

UpdateGhost4 proc
    mov dl,G4xPos
    mov dh,G4yPos
    call Gotoxy
    movzx eax,dh
    sub eax,2
    mov bl,85
    mul bl
    movzx ebx,dl
    sub ebx,10
    add eax,ebx
    mov esi, offset mazeArray
    mov bl,previousElement4
    cmp dl,10
    je store6
    cmp dl,95
    je store6
    cmp dh,2
    je store6
    cmp dh,26
    je store6
    cmp bl,0
    je printdot
    cmp bl,-1
    je store1
    cmp bl,2
    je store1
    cmp bl,3
    je store1

    store6:
    mov bl,6
    mov[esi+eax],bl
    mwrite " "
    jmp quit
    store1:
    mwrite " "
    mov bl,-1
    mov [esi+eax],bl
    jmp quit
    printdot:
        mov bl,0
        mov [esi+eax],bl
        mov eax,lightgray
        call settextcolor
        mwrite "."
    quit:
    ret

UpdateGhost4 endp

checkCollisionG4 proc
    push ebp
    mov ebp,esp
    movzx eax, G4yPos    ; Row index
    movzx ebx, G4xPos    ; Column index
    sub eax,2
    mov ecx,85
    mul ecx
    sub ebx,10
    add eax,ebx
    mov ebx,eax
    mov esi,offset mazeArray
    mov al, [esi + eax]
    mov ah,0
;3 no dot zone
;5 fruits
;6 teleportaion point
;-1 already collected dots or path
 ;1 wall detected
    cmp al, 0            
    je quit    
    cmp al,3
    je quit
    cmp al,-1
    je quit
    cmp al,6
    je callG4teleport
    cmp al,4
    je callendlife
    mov num,1
    mov edi,offset [num]
    mov [ebp+8],edi
    jmp quit

    callG4teleport:
        call teleportG4
        jmp quit
    callendlife:
    call endlife
    quit:
    pop ebp
    ret

checkCollisionG4 endp

teleportG4 proc
    cmp G4ypos,12
    jl checkup
    cmp G4ypos,15
    jg checkdown
    cmp G4xpos,10
    jne checkright

    inc G4xpos
    call UpdateGhost4
    mov G4xpos,93
    jmp quit

    checkright:
    cmp G4xpos,94
    jne quit

    dec G4xpos
    call UpdateGhost4
    mov G4xpos,11
    jmp quit

    checkup:
    cmp G4xpos,45
    jl quit
    cmp G4xpos,60
    jg quit
    cmp G4ypos,2
    jne checkdown
    inc G4ypos
    call UpdateGhost4
    mov G4ypos,25
    jmp quit

    checkdown:
    cmp G4xpos,45
    jl quit
    cmp G4xpos,60
    jg quit
    cmp G4ypos,26
    jne quit
    dec G4ypos
    call UpdateGhost4
    mov G4ypos,3
    jmp quit

    quit:
    ret
teleportG4 endp

;decrementing life
endlife proc
    mov eax,1000
    call delay

    dec lives
    mov al,lives
    cmp al,0
    je gameOver

        call updateplayer
    call updateGhost1

    mov dh,20
    mov dl,52
    mov ypos,dh
    mov xpos,dl

    mov dh,44
    mov dl,12
    mov G1xpos,dh
    mov G1ypos,dl

    mov dh,48
    mov dl,12
    mov G2xpos,dh
    mov G2ypos,dl

    mov dh,52
    mov dl,12
    mov G3xpos,dh
    mov G3ypos,dl

    mov dh,56
    mov dl,12
    mov G4xpos,dh
    mov G4ypos,dl
    


    call drawWindow

endlife endp

;game over screen. lives all lost
gameOver proc
call clrscr
mov eax,1000
call delay
mov dl,35
mov dh,5
call gotoxy
mov eax,lightred
call settextcolor

mwrite "_ _ _ _____   ___  ___  ___ _____   _____  _   _ ___________ _ _ _ "
mov dl,30
mov dh,6
call gotoxy
mwrite "| | | |  __ \ / _ \ |  \/  ||  ___| |  _  || | | |  ___| ___ \ | | |"
mov dl,30
mov dh,7
call gotoxy
mwrite "| | | | |  \// /_\ \| .  . || |__   | | | || | | | |__ | |_/ / | | ||"
mov dl,30
mov dh,8
call gotoxy
mwrite "| | | | | __ |  _  || |\/| ||  __|  | | | || | | |  __||    /| | | |"
mov dl,30
mov dh,9
call gotoxy
mwrite "|_|_|_| |_\ \| | | || |  | || |___  \ \_/ /\ \_/ / |___| |\ \|_|_|_|"
mov dl,30
mov dh,10
call gotoxy
mwrite "(_|_|_)\____/\_| |_/\_|  |_/\____/   \___/  \___/\____/\_| \_(_|_|_)"
mov dl,30
mov dh,15
call gotoxy
mwrite "Player name: "
mov edx,offset username
call writestring
mov dl,30
mov dh,17
call gotoxy
mwrite "Yours score: "
mov eax,score
call writeint

mov dl,35
mov dh,20
call gotoxy
call waitmsg

exit
gameOver endp

;checking if level complete
checkLevel proc
    mov ecx, 25
    mov esi, OFFSET mazeArray
     l1:
        mov ebx,ecx
        mov ecx,85
        l2:
            mov al,  [esi]
            cmp al,0
            je NotComplete
            inc esi
         loop l2
         mov ecx,ebx
    loop l1
    call initializetozero
    call clrscr
    mov eax,lightgreen
    call settextcolor
    mov dl,20
    mov dh,5
    call gotoxy
    inc level;
    mwrite "   _     U _____ u__     __ U _____ u  _            ____   U  ___ u  __  __    ____      _     U _____ u  _____  U _____ u "
    mov dl,20
    mov dh,6
    call gotoxy
    mwrite "  |'|    \| ___'|/\ \   /'/u\| ___'|/ |'|        U /'___|   \/'_ \/U|' \/ '|uU|  _'\ u  |'|    \| ___'|/ |_ ' _| \| ___'|/ "
    mov dl,20
    mov dh,7
    call gotoxy
    mwrite "U | | u   |  _|'   \ \ / //  |  _|' U | | u      \| | u     | | | |\| |\/| |/\| |_) |/U | | u   |  _|'     | |    |  _|'   "
    mov dl,20
    mov dh,8
    call gotoxy
    mwrite " \| |/__  | |___   /\ V /_,-.| |___  \| |/__      | |/__.-,_| |_| | | |  | |  |  __/   \| |/__  | |___    /| |\   | |___   "
     mov dl,20
    mov dh,9
    call gotoxy
    mwrite "  |_____| |_____| U  \_/-(_/ |_____|  |_____|      \____|\_)-\___/  |_|  |_|  |_|       |_____| |_____|  u |_|U   |_____|  "
    mov dl,20
    mov dh,10
    call gotoxy
    mwrite "  //  \\  <<   >>   //       <<   >>  //  \\      _// \\      \\   <<,-,,-.   ||>>_     //  \\  <<   >>  _// \\_  <<   >>  "
    mov dl,20
    mov dh,11
    call gotoxy
    mwrite " (_')('_)(__) (__) (__)     (__) (__)(_')('_)    (__)(__)    (__)   (./  \.) (__)__)   (_')('_)(__) (__)(__) (__)(__) (__) "

    call crlf
    
    mov dl,30
    mov dh,20
    call gotoxy
    mov eax,5000
    call delay
    call waitmsg
    call waitmsg
    NotComplete:
    ret
checkLevel endp

;if level complete initialize array to zero
initializetozero proc
    mov ecx,25
    mov esi,offset mazeArray
    l1:
        mov ebx,ecx
        mov ecx,85
        l2:
            mov al, 0
            mov [esi],al
            inc esi
         loop l2
         mov ecx,ebx
    loop l1
    mov dh,20
    mov dl,52
    mov ypos,dh
    mov xpos,dl

    mov dh,46
    mov dl,12
    mov G1xpos,dh
    mov G1ypos,dl

    mov dh,50
    mov dl,12
    mov G2xpos,dh
    mov G2ypos,dl

    mov dh,54
    mov dl,12
    mov G3xpos,dh
    mov G3ypos,dl

    mov dh,60
    mov dl,12
    mov G4xpos,dh
    mov G4ypos,dl
    ret

initializetozero endp

;end screen after winning game
displayEndScreen proc
    call clrscr
    mov eax,lightgreen
    call settextcolor
    mov dh,5
    mov dl,0
    call gotoxy
    mwrite "   ______    ___   ____  _____   ______  _______          _     _________  _____  _____  _____          _     _________  _____   ___   ____  _____   ______   "
    mov dh,6
    mov dl,0
    call gotoxy
    mwrite " .' ___  | .'   `.|_   \|_   _|.' ___  ||_   __ \        / \   |  _   _  ||_   _||_   _||_   _|        / \   |  _   _  ||_   _|.'   `.|_   \|_   _|.' ____ \  "
    mov dh,7
    mov dl,0
    call gotoxy
    mwrite "/ .'   \_|/  .-.  \ |   \ | | / .'   \_|  | |__) |      / _ \  |_/ | | \_|  | |    | |    | |         / _ \  |_/ | | \_|  | | /  .-.  \ |   \ | |  | (___ \_| "
    mov dh,8
    mov dl,0
    call gotoxy
    mwrite "| |       | |   | | | |\ \| | | |   ____  |  __ /      / ___ \     | |      | '    ' |    | |   _    / ___ \     | |      | | | |   | | | |\ \| |   _.____`.  "
    mov dh,9
    mov dl,0
    call gotoxy
    mwrite "\ `.___.'\\  `-'  /_| |_\   |_\ `.___]  |_| |  \ \_  _/ /   \ \_  _| |_      \ \__/ /    _| |__/ | _/ /   \ \_  _| |_    _| |_\  `-'  /_| |_\   |_ | \____) | "
    mov dh,10
    mov dl,0
    call gotoxy
    mwrite " `.____ .' `.___.'|_____|\____|`._____.'|____| |___||____| |____||_____|      `.__.'    |________||____| |____||_____|  |_____|`.___.'|_____|\____| \______.' "


    mov dh,15
    mov dl,20
    call gotoxy
    mwrite " _  _  ____  ____   ___   _____  _____   ____      ____   ___   ____  _____  _  _  "
    mov dh,16
    mov dl,20
    call gotoxy
    mwrite "| || ||_  _||_  _|.'   `.|_   _||_   _| |_  _|    |_  _|.'   `.|_   \|_   _|| || | "
    mov dh,17
    mov dl,20
    call gotoxy
    mwrite "| || |  \ \  / / /  .-.  \ | |    | |     \ \  /\  / / /  .-.  \ |   \ | |  | || | "
     mov dh,18
    mov dl,20
    call gotoxy
    mwrite "| || |   \ \/ /  | |   | | | '    ' |      \ \/  \/ /  | |   | | | |\ \| |  | || | "
     mov dh,19
    mov dl,20
    call gotoxy
    mwrite "|_||_|   _|  |_  \  `-'  /  \ \__/ /        \  /\  /   \  `-'  /_| |_\   |_ |_||_| "
     mov dh,20
    mov dl,20
    call gotoxy
    mwrite "(_)(_)  |______|  `.___.'    `.__.'          \/  \/     `.___.'|_____|\____|(_)(_) "

    mov dl,15
    mov dh,23
    call gotoxy
    mwrite "Player name: "
    mov edx,offset username
    call writestring
    mov dl,15
    mov dh,25
    call gotoxy
    mwrite "Yours score: "
    mov eax,score
    call writeint

    mov dl,15
    mov dh,27
    call gotoxy
    mov eax,500
    call delay
    call waitmsg
    call menuscreen
    ret

displayEndScreen endp

;array not part of game just to check if everythings working
drawarray proc
mov dl,0
mov dh,30
call gotoxy
 mov ecx, 25
 mov esi, OFFSET mazeArray
 l1:
    mov ebx,ecx
    mov ecx,85
    l2:
    mov ah,0
        mov al,  [esi]
        call writeint
        
        inc esi
     loop l2
     call Crlf
     mov ecx,ebx
loop l1
    ; Wait for a keypress
    call ReadChar
    ret

drawarray endp
END main


