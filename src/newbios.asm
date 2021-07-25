DEFSECT ".freebios",  CODE AT 0000H
SECT ".freebios"
; ----------------------

	DW	hreset          ; 00 - NMI - System Start-up (Hard reset)
	DW	div_0           ; 01 - NMI - Division by 0 exception
	DW	sreset          ; 02 - NMI - System Reset (Soft reset)
	DW	int03_2108      ; 03 - IRQ - PRC Copy Complete
	DW	int04_210E      ; 04 - IRQ - PRC Frame Divider Overflow
	DW	int05_2114      ; 05 - IRQ - Timer2 Upper-8 Underflow
	DW	int06_211A      ; 06 - IRQ - Timer2 Lower-8 Underflow (8-bit only)
	DW	int07_2120      ; 07 - IRQ - Timer1 Upper-8 Underflow
	DW	int08_2126      ; 08 - IRQ - Timer1 Lower-8 Underflow (8-bit only)
	DW	int09_212C      ; 09 - IRQ - Timer3 Upper-8 Underflow
	DW	int0A_2132      ; 0A - IRQ - Timer3 Pivot
	DW	int0B_2138      ; 0B - IRQ - 32Hz (From 256Hz Timer) 
	DW	int0C_213E      ; 0C - IRQ - 8Hz (From 256Hz Timer) 
	DW	int0D_2144      ; 0D - IRQ - 2Hz (From 256Hz Timer) 
	DW	int0E_214A      ; 0E - IRQ - 1Hz (From 256Hz Timer) 
	DW	int0F_2150      ; 0F - IRQ - IR Receiver
	DW	int10_2156      ; 10 - IRQ - Shock Sensor
	DW	sreset          ; 11
	DW	sreset          ; 12
	DW	reticode        ; 13
	DW	int14_219E      ; 14 - IRQ - Cartridge IRQ 
	DW	int15_215C      ; 15 - IRQ - Power Key
	DW	int16_2162      ; 16 - IRQ - Right Key
	DW	int17_2168      ; 17 - IRQ - Left Key
	DW	int18_216E      ; 18 - IRQ - Down Key
	DW	int19_2174      ; 19 - IRQ - Up Key
	DW	int1A_217A      ; 1A - IRQ - C Key
	DW	int1B_2180      ; 1B - IRQ - B Key
	DW	int1C_2186      ; 1C - IRQ - A Key
	DW	int1D_218C      ; 1D - IRQ - Unknown
	DW	int1E_2192      ; 1E - IRQ - Unknown
	DW	int1F_2198      ; 1F - IRQ - Unknown
	DW	0FFF1h          ; 20 - IRQ - User IRQ Routine at PC 0xFFF1
	DW	Intr21h         ; 21 - ROU - Suspend System
	DW	reticode        ; 22
	DW	reticode        ; 23
	DW	Intr24h         ; 24 - ROU - Shutdown System
	DW	reticode        ; 25
	DW	Intr26h         ; 26 - ROU - Set default LCD Constrast
	DW	Intr27h         ; 27 - ROU - Increase or decrease Contrast based of Zero flag...
	DW	Intr28h         ; 28 - ROU - Apply default LCD Constrast
	DW	Intr29h         ; 29 - ROU - Get default LCD Contrast
	DW	Intr2Ah         ; 2A - ROU - Set temporary LCD Constrast
	DW	Intr2Bh         ; 2B - ROU - Turn LCD On
	DW	Intr2Ch         ; 2C - ROU - Initialize LCD
	DW	Intr2Dh         ; 2D - ROU - Turn LCD Off
	DW	Intr2Eh         ; 2E - ROU - Check if Register 0x01 Bit 7 is set,  if not,  it set bit 6 and 7 
	DW	reticode        ; 2F
	DW	reticode        ; 30
	DW	reticode        ; 31
	DW	reticode        ; 32
	DW	reticode        ; 33
	DW	reticode        ; 34
	DW	reticode        ; 35
	DW	reticode        ; 36
	DW	reticode        ; 37
	DW	reticode        ; 38
	DW	Intr39h         ; 39 - ROU - Disable Cartridge and LCD
	DW	Intr3Ah         ; 3A - ROU - Enable Cartridge and LCD
	DW	reticode        ; 3B
	DW	reticode        ; 3C
	DW	Intr3Dh         ; 3D - ROU - Test Register 0x53 Bit 1 and invert Zero flag
	DW	Intr3Eh         ; 3E - ROU - Read structure,  write 0xFF,  compare values and optionally jump to subroutine...
	DW	Intr3Fh         ; 3F - ROU - Set PRC Rate
	DW	Intr40h         ; 40 - ROU - Get PRC Rate
	DW	Intr41h         ; 41 - ROU - Test Register 0x01 Bit 3
	DW	reticode        ; 42
	DW	reticode        ; 43
	DW	reticode        ; 44
	DW	reticode        ; 45
	DW	reticode        ; 46
	DW	reticode        ; 47
	DW	reticode        ; 48
	DW	reticode        ; 49
	DW	reticode        ; 4A
	DW	0000h           ; 4B
	DW	Intr4Ch         ; 4C - ROU - LD [IY], 02h ; wait B*16 Cycles ; MOV [IY], 00h

	ram_vector EQU 1FFDh

; Hard reset
hreset:
	LD BR, #20h				; BR to 20XXh
	XOR A, A
	LD EP, A
	LD [BR:08h], #02h		; Reset seconds counter
	OR [BR:08h], #01h		; Enable seconds counter
	LD [BR:00h], #7Ch		; Preset contrast to 1Fh,  disable cartridge/LCD
	LD [BR:02h], #00h		; Signal cold reset,  bit 2=0: Invalid time
; Soft reset
sreset:
	LD SC, #0C0h			; Disable interrupts
	LD BR, #20h				; BR to 20XXh
	XOR A, A
	LD EP, A
	LD XP, A
	LD YP, A
	LD SP, #2000h			; Init stack
	LD [BR:80h],  #00h		; Disable PRC
	LD NB,  #01h
	JRL dobanking
; ----------------------
dobanking:
	OR [BR:00h], #03h		; Enable cartridge/LCD
	OR [BR:01h], #30h		; ???
	OR [BR:02h], #0C0h		; ???
	CARL init_io
	LD IX, #Graphics
	LD [2082h], IX
	LD [BR:84h], B			; PRC map tile base = FreeBIOS graphics
	LD [BR:85h], B			; PRC map vertical scroll = 00h
	LD [BR:86h], B			; PRC map horizontal scroll = 00h
	LD [BR:87h], B
	LD [BR:88h], B
	LD [BR:89h], B			; PRC sprite tile base = 000000h
	; Clear RAM
	XOR A, A
	LD IX, #1000h
clearram_1:
	LD [IX], A
	INC IX
	CP IX, #2000h
	JRL NZ, clearram_1
	; Init LCD
	CARL init_lcd			; Init LCD
	LD [BR:0FEh], #0AFh		; Display on
	CARL clear_lcd			; Clear the LCD directly
	OR [BR:80h], #0Ah		; Enable PRC map (FreeBIOS)
	OR [BR:81h], #01h		; Set bit 0
	; Detect low power
	BIT [BR:10h], #20h
	JRL NZ, freebioslogo
checkgame:
	CARL checkcartridge
	JRL NZ, freebioslogo
startgame:
	; Restore default PRC map
	XOR A, A
	LD [BR:80h], #00h		; Disable PRC
	LD [BR:81h], #07h
	LD [BR:82h], A
	LD [BR:83h], A			; PRC map tile base = 000000h
	AND [BR:01h], #0EFh		; Clear reg[00h] bit 4
	; Clear RAM again
	LD IX, #1000h
clearram_2:
	LD [IX], A
	INC IX
	CP IX, #2000h
	JRL NZ, clearram_2
	; Initialise registers
	LD BA, #0000h
	LD HL, BA
	LD IX, BA
	LD IY, BA
	LD B, [BR:52h]			; B = power on keys
	LD A, #0FFh				; A = cart type
	AND SC, #0C0h			; Clear all flags except interrupt flag
	; Jump to game entrypoint
	JRL 2102h

; Detect cartridge (FreeBIOS)
checkcartridge:
	LD IX, #21A4h
	LD IY, #nintendo_string
	LD B, #8
checkloop:
	LD A,[IX]
	CP A,[IY]
	JRL NZ, checkfail
	INC IX
	INC IY
	DJR NZ, checkloop
checkfail:
	RET
nintendo_string:
	DB "NINTENDO"

; Draw FreeBIOS logo (FreeBIOS)
freebioslogo:
	LD B, #03h
freebioslogo_loop:
	PUSH BA
	; Draw logo
	LD A, #01h
	LD IX, #137Dh
	LD B, #03h
	CARL drawsequence
	LD IX, #1388h
	LD B, #04h
	CARL drawsequence
	; Draw low power
	BIT [BR:10h], #20h
	JRL Z, freebioslogo_haspower
	LD IX, #1394h
	LD A, #08h
	LD B, #04h
	CARL drawsequence
freebioslogo_haspower:
	; Draw no-cartridge
	CARL checkcartridge
	JRL Z, freebioslogo_hascart
	LD IX, #13A0h
	LD A, #0Ch
	LD B, #04h
	CARL drawsequence
freebioslogo_hascart:
	; Delay
	CARL delay_some
	; Clear low power
	LD IX, #1394h
	LD A, #00h
	LD B, #04h
	CARL drawfixed
	; Delay
	CARL delay_some
	POP BA
	DJR NZ, freebioslogo_loop
	; Clear no-cartridge
	LD IX, #13A0h
	LD A, #00h
	LD B, #04h
	CARL drawfixed
	; Delay
	CARL delay_some
	JRL checkgame

; Draw fixed (FreeBIOS)
drawfixed:
	LD [IX], A
	INC IX
	DJR NZ, drawfixed
	RET

; Draw sequence (FreeBIOS)
drawsequence:
	LD [IX], A
	INC IX
	INC A
	DJR NZ, drawsequence
	RET

; Delay some time (FreeBIOS)
delay_some:
	LD A, #255
delay_some_loop1:
	LD B, #255
delay_some_loop2:
	DJR NZ, delay_some_loop2
	DEC A
	JRL NZ, delay_some_loop1
	RET

; Initialise I/O
init_io:
	LD B, #00h
	LD [BR:10h], #08h		; Battery sensor
	AND [BR:19h], #0CFh		; Clear Timer 1 but leave oscillator enablers
	LD [BR:20h], B
	LD [BR:21h], #30h		; cartridge interrupts priority 3
	LD [BR:22h], #02h		; IR/shock priority 2
	LD [BR:23h], B
	LD [BR:24h], #02h		; Enable 1Hz timer interrupt
	LD [BR:25h], B
	LD [BR:26h], B
	LD [BR:40h], B			; Disable 256Hz timer
	LD [BR:44h], B			; ???
	LD [BR:50h], #0FFh		; ???
	LD [BR:51h], B			; ???
	LD [BR:54h], B			; ???
	LD [BR:55h], B			; ???
	OR [BR:60h], #0Ch		; Set EEPROM pins high
	AND [BR:61h], #0FBh		; EEPROM data as input
	OR [BR:61h], #08h		; EEPROM clock as output
	OR [BR:61h], #04h		; EEPROM data as output
	LD [BR:61h], #20h		; IR disable as output, all others as input
	LD [BR:60h], #32h		; Disable IR
	LD [BR:62h], B			; ???
	LD [BR:70h], B			; ???
	LD [BR:71h], B			; Disable sound
	LD [BR:0FEh], #81h		; Set contrast...
	LD [BR:0FEh], #1Fh		; ...to 1Fh
	RET

; Initialise LCD
init_lcd:
	PUSH HL
	LD HL, #20FEh
	LD [HL], #0E3h			; ???
	LD [HL], #0A4h			; Set all pixels: disable
	LD [HL], #0ADh			; ???
	LD [HL], #00h			; Set column 00h
	LD [HL], #10h
	LD [HL], #0EEh			; ???
	LD [HL], #40h			; Initial display line to 0
	LD [HL], #0A2h			; Max contrast: disable
	LD [HL], #0A0h			; Invert half horizontal: disable
	LD [HL], #0C0h			; From top to bottom
	LD [HL], #0A6h			; Invert all pixels: disable
	LD [HL], #2Fh			; Turn on internal voltage booster & regulator
	POP HL
	RET

; Clear LCD directly
clear_lcd:
	LD HL, #20FEh			; mem[20FE]
	LD [HL], #0E3h			; ??
	LD [HL], #0B0h			; Set page 0
clear_lcd_B0_to_B8:
	LD [HL], H				; Write page
	LD [HL], #00h			; Set column x0
	LD [HL], #10h			; Set column 0x
	LD B, #60h				; Number of columns per page
clear_lcd_clearcolumns:
	LD [BR:0FFh], #00h
	DJR NZ, clear_lcd_clearcolumns
	INC H					; Increase the page
	CP H, #0B8h				; Check if reached the last page
	JRL NZ, clear_lcd_B0_to_B8
	RET

int03_2108:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2108h

int04_210E:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 210Eh

int05_2114:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2114h

int06_211A:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 211Ah

int07_2120:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2120h

int08_2126:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2126h

int09_212C:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 212Ch

int0A_2132:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2132h

int0B_2138:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2138h

int0C_213E:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 213Eh

int0D_2144:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2144h

int0E_214A:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 214Ah

int0F_2150:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2150h

int10_2156:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2156h

int14_219E:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 219Eh

int16_2162:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2162h

int17_2168:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2168h

int18_216E:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 216Eh

int19_2174:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2174h

int1A_217A:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 217Ah

int1B_2180:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2180h

int1C_2186:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2186h

int1D_218C:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 218Ch

int1E_2192:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2192h

int1F_2198:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h
	CARL Z, IntrAlt
	POP BR
	POP EP
	JRL 2198h

int15_215C:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #20h		; Handle IRQs in cartridge
	JRL NZ, int15_215C_2
	BIT [BR:01h], #10h		; Test reg[01h] bit 4
	JRL NZ, sreset			; Reset if set (shutdown)
	BIT [BR:71h], #04h		; Cart power
	JRL Z, int15_215C_3
	BIT [BR:02h], #40h		; ???
	JRL Z, int15_215C_3
	; Cart power is off and something else...
	AND [BR:71h], #0FBh
	OR [BR:02h], #80h
int15_215C_3:
	BIT [BR:01h], #80h		; RAM vector defined?
	JRL Z, int15_215C_4
	BIT [BR:02h], #20h		; ???
	JRL NZ, int15_215C_5
	POP BR
	POP EP
	JRL ram_vector
int15_215C_2:				; Handle cartridge power button interrupt
	POP BR
	POP EP
	JRL 215Ch
int15_215C_4:				; No RAM vector
	OR [BR:01h], #20h		; Set handle IRQs in cartridge
	BIT [BR:02h], #20h		; ???
	JRL NZ, int15_215C_2
int15_215C_5:				; Exit power button IRQ
	LD [BR:29h], #80h		; Mark as complete
	POP BR
	POP EP
	RETE

; Interrupt alternative (when IRQ not handled by the cartridge)
IntrAlt:
	BIT [BR:71h], #04h		; Cart power
	JRL Z, IntrAlt_haspower
	BIT [BR:02h], #40h		; ???
	JRL Z, IntrAlt_haspower
	; Cart power is off and something else...
	AND [BR:71h], #0FBh
	OR [BR:02h], #80h
IntrAlt_haspower:
	BIT [BR:01h], #80h		; RAM vector defined?
	JRL Z, IntrAlt_noramvector
	ADD SP, #0003h			; Unstack interrupt return address
	POP BR
	POP EP
	JRL ram_vector
IntrAlt_noramvector:
	OR [BR:01h], #20h		; Set handle IRQs in cartridge
	RET

reticode:
	RETE

; Suspend/shutdown the console
SuspendShutdown:
	; This is not how the real BIOS does it... but oh well
	AND [BR:80h], #0F7h		; Disable PRC
	LD [BR:0FEh], #0AEh		; Display off
	LD [BR:0FEh], #0ACh		; ???
	LD [BR:0FEh], #28h		; Turn off voltage booster / op-amp buffer
	LD [BR:0FEh], #0A5h		; Set all pixels: enable
	AND [BR:02h], #0E3h		; Unknown
	AND [BR:81h], #0FEh		; ???
	OR [BR:02h], #01h		; ???
	OR [BR:24h], #02h		; Cartridge eject IRQ
	OR [BR:21h], #30h		; Enable cartridge IRQ
	AND [BR:01h], #0DFh		; Disable cart interrupts
	AND [BR:02h], #0E3h		; ???
	PUSH SC
	LD SC, #80h				; Enable interrupts (!?)
	HALT					; Halt the CPU
	POP SC
	OR [BR:02h], #10h		; ???
	OR [BR:81h], #01h		; ???
	CARL init_lcd			; Init LCD
	LD [BR:0FEh], #0AFh		; Display on
	AND [BR:02h], #0DFh		; Enable cart interrupts
	OR [BR:00h], #03h		; Enable cartridge/LCD
	RET

; INT[42h] - ROU - Suspend system
Intr21h:
	; Suspend system
	PUSH EP
	PUSH BR
	LD SC, #0C0h
	LD EP, #00h
	LD BR, #20h
	; Back up registers
	LD B, [BR:80h]
	LD A, [BR:21h]
	AND A, #0Ch
	PUSH BA
	LD B, [BR:23h]
	LD A, [BR:24h]
	PUSH BA
	LD B, [BR:25h]
	LD A, [BR:26h]
	PUSH BA
	; Setup registers
	LD [BR:23h], #00h
	LD [BR:24h], #00h
	LD [BR:25h], #80h		; Only enable power key interrupt
	LD [BR:26h], #00h
	OR [BR:21h], #0Ch
	LD [BR:29h], #80h
	LD [BR:80h], #00h
	; Something causes the PM to suspend
	CARL SuspendShutdown
	; Restore registers
	POP BA
	LD [BR:25h], B
	LD [BR:26h], A
	POP BA
	LD [BR:23h], B
	LD [BR:24h], A
	POP BA
	LD [BR:80h], B
	AND A, #0F3h
	LD [BR:21h], A
	POP BR
	POP EP
	RETE

; INT[48h] - ROU - Shutdown system
Intr24h:
	; Shutdown system
	LD SC, #0C0h
	LD SP, #2000h
	LD EP, #00h
	LD BR, #20h
	CARL init_io
	LD [BR:23h], #00h
	LD [BR:24h], #00h
	LD [BR:25h], #80h		; Only enable power key interrupt
	LD [BR:26h], #00h
	LD [BR:29h], #80h
	LD [BR:80h], #00h
	LD [BR:21h], #0Ch
	CARL SuspendShutdown
	JRL sreset

; can't be bothered to copy over comments for tons of identical interrupts
Intr26h:
	POP SC
Intr26h_0:
	PUSH EP
	PUSH HL
	LD EP, #00h
	LD HL, #2000h
	SLL A
	SLL A
	AND [HL], #03h
	OR [HL], A
	POP HL
	POP EP
	JRL Intr28h_0
; ----------------------
Intr27h:
	CARL Intr29h_0
	POP SC
	PUSH SC
	JRL Z, Intr27h_Inc
Intr27h_Dec:
	CP A, #3Fh
	JRL Z, Intr27h_Err
	INC A
	JRL Intr27h_SetOk
; ----------------------
Intr27h_Inc:
	OR A, A
	JRL Z, Intr27h_Err
	DEC A
	JRL Intr27h_SetOk
; ----------------------
Intr27h_Err:
	LD A, #0FFh
	RETE
; ----------------------
Intr27h_SetOk:
	CARL Intr26h_0
	XOR A, A
	RETE
; ----------------------
Intr28h:
	POP SC
Intr28h_0:
	CARL Intr29h_0
	JRL Intr2Ah_0
; ----------------------
Intr29h:
	POP SC
Intr29h_0:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	LD A, [BR:00h]
	SRL A
	SRL A
	POP BR
	POP EP
	RET
; ----------------------
Intr2Ah:
	POP SC
Intr2Ah_0:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	LD B, A
	BIT [BR:80h], #08h
	PUSH SC
	AND [BR:80h], #0F7h
	LD [BR:0FEh], #81h
	LD [BR:0FEh], B
	POP SC
	JRL Z, Intr2Ah_1
	OR [BR:80h], #08h
Intr2Ah_1:
	POP BR
	POP EP
	RET
; ----------------------
Intr2Bh:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	CARL init_lcd
	LD [BR:0FEh], #0AFh
	OR [BR:80h], #04h
	OR [BR:81h], #01h
	POP BR
	POP EP
	RETE
; ----------------------
Intr2Ch:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	CARL init_lcd
	POP BR
	POP EP
	RETE
; ----------------------
Intr2Dh:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	AND [BR:80h], #0F7h
	LD [BR:0FEh], #0AEh
	LD [BR:0FEh], #0ACh
	LD [BR:0FEh], #28h
	LD [BR:0FEh], #0A5h
	AND [BR:81h], #0FEh
	POP BR
	POP EP
	RETE
; ----------------------
Intr2Eh:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	LD SC, #0C0h
	BIT [BR:01h], #80h
	JRL NZ, Intr2Eh_0
	OR [BR:01h], #80h
	OR [BR:01h], #40h
	AND [BR:01h], #0DFh
Intr2Eh_0:
	POP BR
	POP EP
	RETE
; ----------------------
Intr39h:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	AND [BR:00h], #0FCh
	POP BR
	POP EP
	RETE
; ----------------------
Intr3Ah:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	OR [BR:00h], #03h
	POP BR
	POP EP
	RETE
; ----------------------
Intr3Dh:
	POP SC
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:53h], #02h
	XOR SC, #01h
	POP BR
	POP EP
	RET
; ----------------------
Intr3Eh:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	PUSH IP
	PUSH IX
	PUSH IY
	PUSH HL
	PUSH B
	LD SC, #0C0h
	LD A, [IX]
	BIT A, #01h
	LD A, SC
	JRL Z, Intr3Eh_0
	ADD IX, #000Ah
	LD H, [IX]
	DEC IX
	LD L, [IX]
	DEC IX
	PUSH HL
	LD B, [IX]
	DEC IX
	JRL Intr3Eh_1
; ----------------------
Intr3Eh_0:
	ADD IX, #0007h
Intr3Eh_1:
	PUSH BA
	LD B, [IX]
	DEC IX
	LD A, [IX]
	DEC IX
	LD H, [IX]
	DEC IX
	LD L, [IX]
	DEC IX
	LD YP, A
	LD IY, HL
	LD A, [IX]
	DEC IX
	LD H, [IX]
	DEC IX
	LD L, [IX]
	LD XP, A
	LD IX, HL
	OR [BR:02h], #80h
	LD [IX], #0FFh
	OR [BR:02h], #80h
	LD A, [IY]
	OR [BR:02h], #80h
	CP A, B
	POP BA
	LD SC, A
	JRL Z, Intr3Eh_2
	POP SC
	LD L, B
	POP BA
	LD H, A
	LD A, B
	PUSH SC
	CARL Intr3Eh_3
Intr3Eh_2:
	POP BA
	AND A, #01h
	POP HL
	POP IY
	POP IX
	POP IP
	POP BR
	POP EP
	RETE
; ----------------------
Intr3Eh_3:
	LD NB, A
	JP HL
; ----------------------
Intr3Fh:
	PUSH EP
	PUSH HL
	LD EP, #00h
	LD HL, #2081h
	AND [HL], #0F1h
	AND A, #07h
	SLL A
	OR [HL], A
	POP HL
	POP EP
	RETE
; ----------------------
Intr40h:
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	LD A, [BR:81h]
	SRL A
	AND A, #07h
	POP BR
	POP EP
	RETE
; ----------------------
Intr41h:
	POP SC
	PUSH EP
	PUSH BR
	LD EP, #00h
	LD BR, #20h
	BIT [BR:01h], #08h
	POP BR
	POP EP
	RET
; ----------------------
Intr4Ch:
	LD [IY], #02h
Intr4Ch_0:
	DJR NZ, Intr4Ch_0
	LD [IY], #00h
	RETE

get_key:
	PUSH A
key_loop:
	LD A, [BR:52h]
	LD B, [BR:52h]
	XOR A, B
	CP A, #0
	JRS NZ, key_loop
	POP A
	AND A, B
	RET

div_0:
	LD EP, #0
	LD BR, #20h
	OR [BR:00h], #03h		; Enable cartridge/LCD
	OR [BR:01h], #30h		; ???
	OR [BR:02h], #0C0h		; ???
	CARL init_io
	LD XP, #0
	LD IX, #Graphics
	LD [2082h], IX
	LD [BR:84h], B			; PRC map tile base = FreeBIOS graphics
	LD [BR:85h], B			; PRC map vertical scroll = 00h
	LD [BR:86h], B			; PRC map horizontal scroll = 00h
	LD [BR:87h], B
	LD [BR:88h], B
	LD [BR:89h], B			; PRC sprite tile base = 000000h
	CARL init_lcd			; Init LCD
	LD [BR:0FEh], #0AFh		; Display on
	CARL clear_lcd			; Clear the LCD directly
	LD [BR:80h], #0Ah		; Enable PRC map (FreeBIOS)
	OR [BR:81h], #01h		; Set bit 0
	
	LD A, #00h
	LD IX, #1360h
	LD B, #192
	CARL drawfixed
	
	LD A, #01h
	LD IX, #137Dh
	LD B, #03h
	CARL drawsequence
	LD IX, #1388h
	LD B, #04h
	CARL drawsequence
	; Draw low power
	LD IX, #1394h
	LD A, #10h
	LD B, #04h
	CARL drawsequence
	
waitkeyup:
	LD A, #4
	CARS get_key
	JRS NZ, waitkeyupa
	JRS waitkeyup

waitkeyupa:
	LD A, #1
	CARS get_key
	JRS NZ, waitkeydown
	JRS waitkeyup

waitkeydown:
	LD A, #5
	CARS get_key
	CP A, #5
	JRL NZ, cont
	JRS waitkeydown

cont:
	LD B, A
	AND A, #1
	JRL Z, sreset
	LD A, B
	AND A, #4
	JRS NZ, waitkeydown
	RETE


	ALIGN 8

Graphics:
	DB 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	DB 00h, 0F8h, 04h, 82h, 0E1h, 0E1h, 31h, 31h
	DB 39h, 39h, 39h, 39h, 39h, 39h, 31h, 31h
	DB 0E1h, 0E1h, 82h, 06h, 0FAh, 04h, 0F8h, 00h
	DB 0FEh, 82h, 0F6h, 0EEh, 82h, 0FEh, 0C6h, 0AAh
	DB 0BAh, 0FFh, 0C2h, 0BFh, 89h, 0BFh, 0C2h, 7Eh
	DB 0FEh, 82h, 0AAh, 0D6h, 0FEh, 8Ah, 0FEh, 0C6h
	DB 0BBh, 0C7h, 0FDh, 0B6h, 0ABh, 0ABh, 0DAh, 7Eh
	DB 7Ch, 7Ch, 40h, 40h, 00h, 38h, 7Ch, 44h
	DB 7Ch, 38h, 00h, 3Ch, 7Ch, 20h, 7Ch, 3Ch
	DB 00h, 00h, 7Ch, 7Ch, 7Ch, 74h, 6Ch, 54h
	DB 64h, 44h, 44h, 44h, 44h, 6Ch, 38h, 00h
	DB 7Ch, 7Ch, 08h, 10h, 7Ch, 7Ch, 00h, 38h
	DB 7Ch, 44h, 7Ch, 38h, 00h, 00h, 00h, 38h
	DB 44h, 44h, 00h, 78h, 14h, 14h, 78h, 00h
	DB 7Ch, 14h, 14h, 68h, 00h, 04h, 7Ch, 04h
	DB 28h, 7Ch, 28h, 7Ch, 28h, 00h, 7Ch, 7Ch
	DB 44h, 7Ch, 38h, 00h, 7Ch, 7Ch, 00h, 3Ch
	DB 7Ch, 40h, 7Ch, 3Ch, 00h, 60h, 10h, 0Ch
	DB 00h, 38h, 44h, 44h, 38h, 00h, 5Ch, 00h

DEFSECT ".credits", DATA AT 0FB0H
SECT ".credits"

	DB "    Freeware    "
	DB "PokemonMini BIOS"
	DB "  Version  1.4  "
	DB " by Team Pokeme "
	DB " and Jhynjhiruu "
