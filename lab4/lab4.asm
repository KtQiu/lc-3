.ORIG       x3000
BRnzp SATRT
STACKPOINT   .FILL       x8000
ROW          .FILL       x0000
COL          .FILL       x0000
maxDistance  .FILL       x0000
dataAddr     .FILL       x3200
HEIGHT       .FILL       x3202
DISTANCE     .FILL       x4000
SATRT
LD     R0    dataAddr   ; load the data in R0
LDR    R1    R0     0   ;R1=ROW
LDR    R2    R0     1   ;R2=COL
ST     R1    ROW                        
ST     R2    COL  
LD     R6    STACKPOINT  ; load the R6 as stack point                                                    
ADD    R1    R1       #-1
ADD    R2    R2       #-1
                        ;init the data of DISTANCE as 0
;
;c-version code
;
; for (i = 0; i < row; ++i){
;         for (j = 0; j < col; ++j){
;                distance[i][j] = 0; 
;         }       
; }
;
LOOP1           
LEA   R5   distance
LEA   R7   #1
JMP   R5                       
; R5 = &(distance+i*col+j)
AND   R0   R0   0
STR   R0   R5   0      ;load the 0 into the DISTANCE[i][j]
;judge whethe needed to do again
ADD   R2    R2   #-1
BRzp  LOOP1              ; finish init
LD    R2    COL
ADD   R2    R2   #-1
ADD   R1    R1   #-1
BRzp  LOOP1
LD    R1    ROW
ADD   R1    R1   #-1
LD    R2    COL
ADD   R2    R2   #-1
LOOP2           
LEA    R5    DIS
LEA    R7    #1
JMP    R5
ADD    R0    R5   0; copy the return value of fun in r0 
LEA    R5    distance     ; now the R5 is the number in DISTANCE[i][j]
LEA    R7    #1
JMP    R5
STR    R0    R5  0
;DIS(I,J) - maxDistance 
LD     R7    maxDistance
NOT    R7    R7
ADD    R7    R7   1
ADD    R7    R7   R0
BRnz   SKIP
ST     R0          maxDistance
SKIP            
ADD     R2          R2          #-1
BRzp    LOOP2
LD      R2          COL
ADD     R2          R0          #-1
ADD     R1          R1          #-1
BRzp    LOOP2
LD      R2          maxDistance
TRAP    x25

;=======================================================
;function mulity()
; use: set the value of R1 * R2 into R5 
mulity          
STR    R2   R6    1; store the initial R1 and R2
STR    R1   R6    0
ADD    R6   R6    2
AND    R5   R5    0
ADD    R1   R1    1
; LOOP3           ADD         R5          R5          R2
;                 ADD         R1          R1          #-1
;      
           BRp         LOOP3
                ; ADD R5, R5, R2
LOOP3           
ADD  R1, R1, #-1
BRn  skipmul
ADD  R5, R5, R2
BRnzp LOOP3
skipmul 
NOT    R2    R2
ADD    R2    R2     #1
ADD    R5    R5     R2  ; set R5 STORE THE result of mulity
LDR    R1    R6     #-2
LDR    R2    R6     #-1
ADD    R6    R6     #-2
RET
                 
;=============================================================== 
; function distance()
; discription
; DISTANCE[I][J]=DISTANCE + I*COL + J
; use: R5  =  address of DISTANCE[I][J] and return R5
;
distance     
STR    R7    R6     0
STR    R2    R6     1
STR    R1    R6     2
ADD    R6    R6     3
LD     R2    COL      
LEA    R5    mulity        
LEA    R7    #1
JMP    R5
LDR    R2    R6     #-2
ADD    R5    R5     R2
LD     R7    DISTANCE  
ADD    R5    R5     R7
LDR    R1    R6     #-1
LDR    R2    R6     #-2
LDR    R7    R6     #-3
ADD    R6    R6     #-3
RET
;=============================================================== 
; function height()
; discription:
; HEIGHT[I][J]=HEIGHT + I*COL + J
; R5  = the address of HEIGHT[I][J] and return R5
;
hight     
STR    R7    R6      0
STR    R2    R6      1
STR    R1    R6      2
ADD    R6    R6      3
LD     R2    COL      
LEA    R5    mulity        
LEA    R7    #1
JMP    R5
LDR    R2    R6      #-2
ADD    R5    R5      R2
LD     R7    HEIGHT  
ADD    R5    R5      R7
LDR    R1    R6      #-1
LDR    R2    R6      #-2
LDR    R7    R6      #-3
ADD    R6    R6      #-3
RET
                
;============================================
; rescursive function DIS()
; c-version codes

; int dis(int i, int j)
; {
;         int k = 0;
;         int temp = 0;
;         if(distance[i][j]) // the res has been caled, direstly return the value   
;                return distance[i][j];   
;            for(k = 0; k < 4; k++){   
;                if(i+dx[k] >= 0 && i+dx[k] < row && j+dy[k] >= 0 && j+dy[k] < col){   
;                    if(height[i][j] > height[ i+dx[k] ][ j+dy[k] ]){     // if h[i][j] is higher   
;                       temp = dis(i+dx[k],j+dy[k]);     
;                       distance[i][j] = distance[i][j] > temp ? distance[i][j] : temp + 1;   
;                    }   
;                }   
;            }   
;         return distance[i][j];
; }           
;
;push all the six registers
;|R7    |  return address  (the loaction of initial R6)
;|R4    | initial R4
;|R3    | initial R3
;|R2    | J
;|R1    | I
;|R0    | initial R0
;|temp  | maxDistance
;|R6    |<== point to this (the first time: x8007)
; R5 use for return value
;
;
DIS             
STR   R7   R6   #0    ; R7 is the return address
STR   R4   R6   #1    ; R4 
STR   R3   R6   #2    
STR   R2   R6   #3    ;R2 is J
STR   R1   R6   #4    ;R1 is I
STR   R0   R6   #5    ;r0 is temp          
ADD   R6   R6   #6    ;renew the location of R6  
AND   R0   R0   #0    ;temp = 0
STR   R0   R6   #0          ; jububianliang store the tempMAX
ADD   R6   R6   #1
;judge whethe the DISTANCE[i][j] > 0 ?
LEA   R7   #2
LEA   R5   distance   ; fetch DISTANCE
JMP   R5
LDR   R5   R5          #0
BRp   POP                             ; bigger than 0 ==> this DISTANCE has been FETCHed
;I-1                                             ;go to I-1
ADD   R5   R1   #-1
BRn   addI                            ; judge whethe in the bound
LEA    R7   #2
LEA    R5   hight               ;R5 = &HEIGHT[i][j]
JMP    R5
LD     R4   COL                  
NOT    R4   R4
ADD    R4   R4   #1          
ADD    R4   R5   R4          ; R4 = R5 - col = &(HEIGH[i-1][j])
LDR    R3   R5   #0          ; R3 = HEIGHT[i][j]
LDR    R4   R4   #0
NOT    R4   R4
ADD    R4   R4   1          
ADD    R5   R3   R4          ; HEIGHT[i][j] - HEIGHT[i-1][j] <= 0
BRnz   addI
                        ;DIS(I-1,J) - temp
ADD    R1   R1     #-1
LEA    R7   #2
LEA    R5   DIS       ; R5 = address of DISTANCE[i-1][j]
JMP    R5
ADD    R1   R1    1    ; huifu R1 to I
LDR    R4   R6    #-1
NOT    R4   R4
ADD    R4   R4    1
ADD    R4   R5    R4      ; DISTANCE[I-1][J]
BRnz   addI
STR    R5   R6     #-1     
addI          
LD     R0   ROW
NOT    R0   R0
ADD    R0   R0    1
ADD    R0   R0    R1
ADD    R0   R0    1
BRz    subJ
                                ;HEIGHT[I][J] - HEIGHT[I+1][J]
LEA     R7      #2
LEA     R5      hight
JMP     R5
LD      R0      COL
ADD     R4      R0      R5
;
LDR     R3      R5      #0
LDR     R4      R4      #0
NOT     R4      R4
ADD     R4      R4      #1
ADD     R3      R3      R4
BRnz    subJ
                                ;DIS(I+1,J)-temp
ADD     R1      R1      #1
LEA     R7      #2
LEA     R5      DIS
JMP     R5
ADD     R1      R1      #-1
LDR     R4      R6      #-1
NOT     R4      R4
ADD     R4      R4      #1
ADD     R4      R4      R5
BRnz    subJ
STR     R5      R6      #-1
subJ 
ADD     R5      R2      #-1
BRn     addJ
                                ; do HEIGHT[I][J] - HEIGHT[I][J-1]
LEA     R7     #2
LEA     R5     hight
JMP     R5
ADD     R4     R5       #-1
LDR     R3     R5       0
LDR     R4     R4       0
NOT     R4     R4
ADD     R4     R4          #1
ADD     R4     R3          R4
BRnz    addJ
                                ;DIS(I,J-1) - temp
ADD  R2   R2   #-1
LEA  R7   #2
LEA  R5   DIS
JMP  R5
ADD  R2    R2    #1
LDR  R4    R6    #-1         
NOT  R4    R4
ADD  R4    R4    1
ADD  R4    R5      R4
BRnz addJ
STR         R5          R6          #-1
addJ         
LD    R4    COL
NOT   R4    R4
ADD   R4    R4    #1
ADD   R4    R4    R2
ADD   R4    R4    #1
BRz   retrive
LEA   R7     2
LEA   R5     hight
JMP   R5
ADD   R4    R5    1
LDR   R3    R5    0
LDR   R4    R4    0
NOT   R4    R4
ADD   R4    R4    1
ADD   R5    R3    R4
BRnz  retrive      
;do HEIGHT[I][J]-HEIGHT[I][J+1]
;DIS(I,J+1) - temp
ADD     R2     R2    1
LEA     R7     2
LEA     R5     DIS
JMP     R5
ADD     R2     R2    #-1
LDR     R4     R6    #-1
NOT     R4     R4
ADD     R4     R4    #1
ADD     R4     R4    R5
BRnz    retrive
STR     R5          R6          #-1         
;DISTANCE[i][j] = temp + 1;
retrive         
LDR     R0     R6    #-1
ADD     R0     R0    #1
LEA     R7     #2
LEA     R5     distance
JMP     R5
STR     R0     R5    #0
ADD     R5     R0    #0
                
POP        
LDR   R7    R6    #-7
LDR   R4    R6    #-6
LDR   R3    R6    #-5
LDR   R2    R6    #-4
LDR   R1    R6    #-3
LDR   R0    R6    #-2
ADD   R6    R6    #-7
RET
       
.END
