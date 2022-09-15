
;CodeVisionAVR C Compiler V3.39b 
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _data=R4
	.DEF _flag=R3
	.DEF _temp=R5
	.DEF _temp_msb=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_receive_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1F,0xFF,0xFF,0xF0,0x0,0x0,0x3F,0xFF
	.DB  0xFF,0xF0,0x0,0x0,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0x3F,0xFF,0xFF,0xF0,0x0,0x0
	.DB  0x3E,0x6F,0xE4,0xF0,0x0,0x0,0x3E,0xA7
	.DB  0x20,0xF0,0x0,0x40,0x3E,0xB,0x21,0xF0
	.DB  0x1,0xF0,0x3E,0x83,0x20,0xF0,0x0,0xE0
	.DB  0x3E,0x53,0x64,0xF0,0x0,0xE0,0x3F,0xFF
	.DB  0xFF,0xF0,0x0,0x0,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0x3F,0xFF,0xFF,0xF0,0x0,0x0
	.DB  0x3F,0xFF,0xEF,0xF0,0x0,0x0,0x3F,0xFC
	.DB  0xFF,0xF0,0x0,0x0,0x3F,0xFF,0x5F,0xF0
	.DB  0x0,0x0,0x3F,0xEF,0xBF,0xF0,0x0,0x0
	.DB  0x3F,0xFF,0xBF,0xF0,0x0,0x0,0x3F,0x73
	.DB  0xEF,0xF0,0x0,0x0,0x3D,0xDB,0xFF,0xF0
	.DB  0x0,0x0,0x3B,0x7E,0xFF,0xF0,0x0,0x0
	.DB  0xD,0xFD,0xFF,0xF0,0x0,0x0,0x1B,0xEF
	.DB  0xFF,0xF0,0x0,0x0,0x6F,0xFB,0xFF,0xF0
	.DB  0x0,0x0,0xBF,0xDF,0xFF,0xF0,0x0,0x0
	.DB  0x3F,0xFF,0xFF,0xF0,0x0,0x0,0x3F,0xAF
	.DB  0xFF,0xF0,0x0,0x0,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0x3F,0x5F,0xFF,0xF0,0x0,0x0
	.DB  0x3F,0xBF,0xFF,0xF0,0x0,0x0,0x3E,0xFF
	.DB  0xFF,0xF0,0x0,0x0,0xEF,0xEF,0xFF,0xF0
	.DB  0x0,0x0,0xFC,0xFF,0xFF,0xF0,0x0,0x1
	.DB  0x3F,0xFF,0xFF,0xF0,0x0,0x14,0x39,0xFF
	.DB  0xFF,0xF0,0x0,0x18,0x3B,0xFF,0xFF,0xF0
	.DB  0x0,0x30,0x37,0xFF,0xFF,0xF0,0x0,0x10
	.DB  0x37,0xFF,0xFF,0xF0,0x0,0x0,0x2F,0xFF
	.DB  0xFF,0xF0,0x0,0x0,0xF,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0x1F,0xFF,0xFF,0xF0,0x0,0x0
	.DB  0x3F,0xFF,0xFF,0xF0,0x0,0x10,0x3F,0xFF
	.DB  0xFF,0xF0,0x0,0x30,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x38,0x3F,0xFF,0xFF,0xF0,0x0,0x18
	.DB  0x3F,0xFF,0xFF,0xF0,0x0,0x0,0x3F,0xFF
	.DB  0xFF,0xF0,0x0,0x1,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0xEF,0xFF,0xFF,0xF0,0x0,0x0
	.DB  0xEF,0xFF,0xFF,0xF0,0x0,0x0,0x3F,0xFF
	.DB  0xFF,0xF0,0x0,0x0,0x3F,0xFF,0xFF,0xF0
	.DB  0x0,0x0,0x3F,0xFF,0xFF,0xF0,0x0,0x0
	.DB  0x1F,0xFF,0xFF,0xF0,0x3F,0xFF,0xDF,0xFF
	.DB  0xFF,0xF0,0x3F,0xDF,0xFF,0xFF,0xFF,0xF0
	.DB  0x3F,0xDF,0xFF,0xFF,0xFF,0xF0,0x30,0x88
	.DB  0x13,0x2,0x4,0x70,0x30,0x88,0x13,0x2
	.DB  0x4,0x70,0x30,0x89,0x3,0x10,0x4,0x70
	.DB  0x30,0x89,0x83,0x10,0x4,0x70,0x30,0x0
	.DB  0x13,0x2,0x0,0x30,0x30,0x20,0x13,0x2
	.DB  0x1,0x30,0x3B,0xAC,0xB7,0xEA,0xCF,0x70
	.DB  0x3F,0xFF,0xFF,0xFF,0xFF,0xF0,0x3F,0xFF
	.DB  0xFF,0xFF,0xFF,0xF0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x18C
	.DW  _logo_bmp
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;#include <stdlib.h>
;#define     ADC0        0
;#define		ADC1		1
;#define		ADC2		2
;#define		ADC3		3
;#define		ADC4		4
;#define		ADC5		5
;
;#define WIDTH 128
;#define HEIGHT 64
;#define WIRE_MAX 32
;#define addr_oled 0x78
;#define TW_START 0x08 // start
;#define  TW_REP_START  0x10    // repeat start
;#define  TW_MT_SLA_ACK 0x18   // truyen slave addr de ghi co ack
;#define  TW_MT_SLA_NACK 0x20 //  truyen slave addr de ghi  ko co ack
;#define  TW_MR_SLA_ACK 0x40   // truyen slave addr de doc co ack
;#define  TW_MT_DATA_ACK 0x28 // gui dl co ack
;#define  TW_MT_DATA_NACK 0x30  // nhan dl khong co ack
;#define SSD1306_COLUMNADDR          0x21 ///< See datasheet
;#define SSD1306_PAGEADDR            0x22        ///< See datasheet
;char data;
;char flag =0 ;
;int temp;
;unsigned char logo_bmp[] =
;{ 0x00,0x00,0x00,0x00,0x00,0x00,
;  0x00,0x00,0x1f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3e,0x6f,0xe4,0xf0,
;  0x00,0x00,0x3e,0xa7,0x20,0xf0,
;  0x00,0x40,0x3e,0x0b,0x21,0xf0,
;  0x01,0xf0,0x3e,0x83,0x20,0xf0,
;  0x00,0xe0,0x3e,0x53,0x64,0xf0,
;  0x00,0xe0,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xef,0xf0,
;  0x00,0x00,0x3f,0xfc,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0x5f,0xf0,
;  0x00,0x00,0x3f,0xef,0xbf,0xf0,
;  0x00,0x00,0x3f,0xff,0xbf,0xf0,
;  0x00,0x00,0x3f,0x73,0xef,0xf0,
;  0x00,0x00,0x3d,0xdb,0xff,0xf0,
;  0x00,0x00,0x3b,0x7e,0xff,0xf0,
;  0x00,0x00,0x0d,0xfd,0xff,0xf0,
;  0x00,0x00,0x1b,0xef,0xff,0xf0,
;  0x00,0x00,0x6f,0xfb,0xff,0xf0,
;  0x00,0x00,0xbf,0xdf,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xaf,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0x5f,0xff,0xf0,
;  0x00,0x00,0x3f,0xbf,0xff,0xf0,
;  0x00,0x00,0x3e,0xff,0xff,0xf0,
;  0x00,0x00,0xef,0xef,0xff,0xf0,
;  0x00,0x00,0xfc,0xff,0xff,0xf0,
;  0x00,0x01,0x3f,0xff,0xff,0xf0,
;  0x00,0x14,0x39,0xff,0xff,0xf0,
;  0x00,0x18,0x3b,0xff,0xff,0xf0,
;  0x00,0x30,0x37,0xff,0xff,0xf0,
;  0x00,0x10,0x37,0xff,0xff,0xf0,
;  0x00,0x00,0x2f,0xff,0xff,0xf0,
;  0x00,0x00,0x0f,0xff,0xff,0xf0,
;  0x00,0x00,0x1f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x10,0x3f,0xff,0xff,0xf0,
;  0x00,0x30,0x3f,0xff,0xff,0xf0,
;  0x00,0x38,0x3f,0xff,0xff,0xf0,
;  0x00,0x18,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x01,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0xef,0xff,0xff,0xf0,
;  0x00,0x00,0xef,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x3f,0xff,0xff,0xf0,
;  0x00,0x00,0x1f,0xff,0xff,0xf0,
;  0x3f,0xff,0xdf,0xff,0xff,0xf0,
;  0x3f,0xdf,0xff,0xff,0xff,0xf0,
;  0x3f,0xdf,0xff,0xff,0xff,0xf0,
;  0x30,0x88,0x13,0x02,0x04,0x70,
;  0x30,0x88,0x13,0x02,0x04,0x70,
;  0x30,0x89,0x03,0x10,0x04,0x70,
;  0x30,0x89,0x83,0x10,0x04,0x70,
;  0x30,0x00,0x13,0x02,0x00,0x30,
;  0x30,0x20,0x13,0x02,0x01,0x30,
;  0x3b,0xac,0xb7,0xea,0xcf,0x70,
;  0x3f,0xff,0xff,0xff,0xff,0xf0,
;  0x3f,0xff,0xff,0xff,0xff,0xf0,
;  0x00,0x00,0x00,0x00,0x00,0x00,
;
;};

	.DSEG
;//char mess[10];
;void(*funtion[10])(int,int);
;
;unsigned char buffer[WIDTH*HEIGHT/8]; // 128 cot , 64 hang => co can 1024 byte bieu dien het man hinh
;
;void ADC_init(unsigned char input_channel) {
; 0000 0068 void ADC_init(unsigned char input_channel) {

	.CSEG
_ADC_init:
; .FSTART _ADC_init
; 0000 0069 
; 0000 006A 	ADCSRA |= (1 << ADEN);
	ST   -Y,R17
	MOV  R17,R26
;	input_channel -> R17
	LDS  R30,122
	ORI  R30,0x80
	STS  122,R30
; 0000 006B 
; 0000 006C 	// The voltage reference is selected by the two bits REFS1 and REFS0 in the ADMUX register
; 0000 006D 	// 0 0	< AREF >
; 0000 006E 	// 0 1	< AVCC with external capacitor at AREF pin >
; 0000 006F 	// 1 1	< Internal 2.56V voltage reference with capacitor at AREF pin >
; 0000 0070 	ADMUX |= (1 << REFS0) | (1 << REFS1);
	LDS  R30,124
	ORI  R30,LOW(0xC0)
	STS  124,R30
; 0000 0071 	// Set the result is right adjusted
; 0000 0072 	// Set this bit to one if use result as left adjusted
; 0000 0073 	ADMUX |= (0 << ADLAR);
	LDI  R26,LOW(124)
	LDI  R27,HIGH(124)
	LD   R30,X
	ST   X,R30
; 0000 0074 	// Select input channel for AD_Converter: AD0 - AD7
; 0000 0075 	ADMUX |= input_channel;
	OR   R30,R17
	ST   X,R30
; 0000 0076 	// ADPS[2:0] determine the division factor between the XTAL frequency and the input clock to the ADC
; 0000 0077 	// Required input clock frequency: 50kHz -> 200kHz
; 0000 0078 	// 16MHz / 128 ~ 125kHz
; 0000 0079 	ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
	LDS  R30,122
	ORI  R30,LOW(0x7)
	STS  122,R30
; 0000 007A }
	RJMP _0x20A0005
; .FEND
;
;
;unsigned int ADC_read() {
; 0000 007D unsigned int ADC_read() {
_ADC_read:
; .FSTART _ADC_read
; 0000 007E 	unsigned int res = 0;
; 0000 007F 	ADCSRA |= (1 << ADSC);
	ST   -Y,R17
	ST   -Y,R16
;	res -> R16,R17
	__GETWRN 16,17,0
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0080 	while(ADCSRA & (1 << ADSC));
_0x4:
	LDS  R30,122
	ANDI R30,LOW(0x40)
	BRNE _0x4
; 0000 0081 
; 0000 0082 	res = ADCL;
	LDS  R16,120
	CLR  R17
; 0000 0083 	res |= (ADCH << 8);
	LDS  R30,121
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
; 0000 0084 
; 0000 0085 	return res;
	MOVW R30,R16
	RJMP _0x20A0006
; 0000 0086 }
; .FEND
;
;int ADC_convert(unsigned int ADC) {
; 0000 0088 int ADC_convert(unsigned int ADC) {
_ADC_convert:
; .FSTART _ADC_convert
; 0000 0089 
; 0000 008A 	float temperature = ( ADC * 0.11);
; 0000 008B 
; 0000 008C 	return (int)temperature;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	ADC -> Y+4
;	temperature -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3DE147AE
	RCALL __MULF12
	RCALL __PUTD1S0
	RCALL __CFD1
	RJMP _0x20A0004
; 0000 008D }
; .FEND
;
;void uart_Init(){
; 0000 008F void uart_Init(){
_uart_Init:
; .FSTART _uart_Init
; 0000 0090   UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 0091 UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 0092 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0093 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0094 UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 0095 }
	RET
; .FEND
;interrupt [USART_RXC]void usart_receive_isr (void)
; 0000 0097 {
_usart_receive_isr:
; .FSTART _usart_receive_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0098 
; 0000 0099  data = UDR0;
	LDS  R4,198
; 0000 009A  flag =1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 009B  if(data=='G'){
	LDI  R30,LOW(71)
	CP   R30,R4
	BRNE _0x7
; 0000 009C     int adc_res = 0;
; 0000 009D 	ADC_init(ADC0);
	RCALL SUBOPT_0x0
;	adc_res -> Y+0
	LDI  R26,LOW(0)
	RCALL _ADC_init
; 0000 009E 
; 0000 009F //	while (1) {
; 0000 00A0 		adc_res = ADC_read();
	RCALL _ADC_read
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A1 		temp = ADC_convert(adc_res);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _ADC_convert
	__PUTW1R 5,6
; 0000 00A2         UDR0 = temp;
	STS  198,R5
; 0000 00A3         data =0;
	CLR  R4
; 0000 00A4 
; 0000 00A5 //	}
; 0000 00A6  }
	ADIW R28,2
; 0000 00A7 }
_0x7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void read_Uart(){
; 0000 00A8 void read_Uart(){
; 0000 00A9 }
;
;void I2c_init(void)
; 0000 00AC {
_I2c_init:
; .FSTART _I2c_init
; 0000 00AD      TWSR = 0x00;
	LDI  R30,LOW(0)
	STS  185,R30
; 0000 00AE      TWBR = 72 ;
	LDI  R30,LOW(72)
	STS  184,R30
; 0000 00AF }
	RET
; .FEND
;
;
;
;unsigned char I2c_start(unsigned char address)
; 0000 00B4 {
_I2c_start:
; .FSTART _I2c_start
; 0000 00B5     char   twst;
; 0000 00B6 
; 0000 00B7 	// send START condition
; 0000 00B8 	TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	address -> R16
;	twst -> R17
	LDI  R30,LOW(164)
	STS  188,R30
; 0000 00B9 
; 0000 00BA 	// wait until transmission completed
; 0000 00BB 	while(!(TWCR & (1<<TWINT)));
_0x8:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x8
; 0000 00BC 
; 0000 00BD 	// check value of TWI Status Register. Mask prescaler bits.
; 0000 00BE 	twst = TWSR & 0xF8;
	RCALL SUBOPT_0x1
; 0000 00BF 	if ( (twst != TW_START) && (twst != TW_REP_START)) return 1;
	CPI  R17,8
	BREQ _0xC
	CPI  R17,16
	BRNE _0xD
_0xC:
	RJMP _0xB
_0xD:
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0000 00C0 
; 0000 00C1 	// send device address
; 0000 00C2 	TWDR = address;
_0xB:
	RCALL SUBOPT_0x2
; 0000 00C3 	TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 00C4 
; 0000 00C5 	// wail until transmission completed and ACK/NACK has been received
; 0000 00C6 	while(!(TWCR & (1<<TWINT)));
_0xE:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0xE
; 0000 00C7 
; 0000 00C8 	// check value of TWI Status Register. Mask prescaler bits.
; 0000 00C9 	twst = TWSR & 0xF8;
	RCALL SUBOPT_0x1
; 0000 00CA 	if ( (twst != TW_MT_SLA_ACK) && (twst != TW_MR_SLA_ACK) ) return 1; // kiem tra ack
	CPI  R17,24
	BREQ _0x12
	CPI  R17,64
	BRNE _0x13
_0x12:
	RJMP _0x11
_0x13:
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0000 00CB 
; 0000 00CC 	return 0;
_0x11:
	RJMP _0x20A0007
; 0000 00CD 
; 0000 00CE }/* i2c_start */
; .FEND
;
;void I2c_start_wait(unsigned char address)
; 0000 00D1 {
; 0000 00D2     char twst;
; 0000 00D3 
; 0000 00D4 
; 0000 00D5     while ( 1 )
;	address -> R16
;	twst -> R17
; 0000 00D6     {
; 0000 00D7         // send START condition
; 0000 00D8         TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
; 0000 00D9 
; 0000 00DA         // wait until transmission completed
; 0000 00DB         while(!(TWCR & (1<<TWINT)));
; 0000 00DC 
; 0000 00DD         // check value of TWI Status Register. Mask prescaler bits.
; 0000 00DE         twst = TWSR & 0xF8;
; 0000 00DF         if ( (twst != TW_START) && (twst != TW_REP_START)) continue;
; 0000 00E0 
; 0000 00E1         // send device address
; 0000 00E2         TWDR = address;
; 0000 00E3         TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 00E4 
; 0000 00E5         // wail until transmission completed
; 0000 00E6         while(!(TWCR & (1<<TWINT)));
; 0000 00E7 
; 0000 00E8         // check value of TWI Status Register. Mask prescaler bits.
; 0000 00E9         twst = TWSR & 0xF8;
; 0000 00EA         if ( (twst == TW_MT_SLA_NACK )||(twst ==TW_MT_DATA_NACK) )
; 0000 00EB         {
; 0000 00EC             /* device busy, send stop condition to terminate write operation */
; 0000 00ED             TWCR = (1<<TWINT) | (1<<TWEN) | (1<<TWSTO);
; 0000 00EE 
; 0000 00EF             // wait until stop condition is executed and bus released
; 0000 00F0             while(TWCR & (1<<TWSTO));
; 0000 00F1 
; 0000 00F2             continue;
; 0000 00F3         }
; 0000 00F4         //if( twst != TW_MT_SLA_ACK) return 1;
; 0000 00F5         break;
; 0000 00F6      }
; 0000 00F7 
; 0000 00F8 }/* i2c_start_wait */
;
;
;unsigned char I2c_rep_start(unsigned char address)
; 0000 00FC {
; 0000 00FD     return I2c_start( address );
;	address -> R17
; 0000 00FE 
; 0000 00FF }/* i2c_rep_start */
;
;
;
;void I2c_stop(void)
; 0000 0104 {
_I2c_stop:
; .FSTART _I2c_stop
; 0000 0105     /* send stop condition */
; 0000 0106     TWCR = (1<<TWINT) | (1<<TWEN) | (1<<TWSTO);
	LDI  R30,LOW(148)
	STS  188,R30
; 0000 0107 
; 0000 0108     // wait until stop condition is executed and bus released
; 0000 0109     while(TWCR & (1<<TWSTO));
_0x26:
	LDS  R30,188
	ANDI R30,LOW(0x10)
	BRNE _0x26
; 0000 010A 
; 0000 010B }/* i2c_stop */
	RET
; .FEND
;
;
;unsigned char I2c_write( unsigned char data )
; 0000 010F {
_I2c_write:
; .FSTART _I2c_write
; 0000 0110     char  twst;
; 0000 0111 
; 0000 0112 	// send data to the previously addressed device
; 0000 0113 	TWDR = data;
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	data -> R16
;	twst -> R17
	RCALL SUBOPT_0x2
; 0000 0114 	TWCR = (1<<TWINT) | (1<<TWEN);
; 0000 0115 
; 0000 0116 	// wait until transmission completed
; 0000 0117 	while(!(TWCR & (1<<TWINT)));
_0x29:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x29
; 0000 0118 
; 0000 0119 	// check value of TWI Status Register. Mask prescaler bits
; 0000 011A 	twst = TWSR & 0xF8;
	RCALL SUBOPT_0x1
; 0000 011B 	if( twst != TW_MT_DATA_ACK) return 1;
	CPI  R17,40
	BREQ _0x2C
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0000 011C 	return 0;
_0x2C:
_0x20A0007:
	LDI  R30,LOW(0)
_0x20A0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 011D 
; 0000 011E }/* i2c_write */
; .FEND
;
;
;
;void write_cmd1(char data){
; 0000 0122 void write_cmd1(char data){
_write_cmd1:
; .FSTART _write_cmd1
; 0000 0123      I2c_start(addr_oled);
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
	RCALL SUBOPT_0x3
; 0000 0124       I2c_write(0x00);
; 0000 0125        I2c_write(data);
	MOV  R26,R17
	RCALL _I2c_write
; 0000 0126        I2c_stop();
	RCALL _I2c_stop
; 0000 0127 }
_0x20A0005:
	LD   R17,Y+
	RET
; .FEND
;
;void cmd_list(unsigned char*c, int n){
; 0000 0129 void cmd_list(unsigned char*c, int n){
_cmd_list:
; .FSTART _cmd_list
; 0000 012A       unsigned char  bytesOut = 1;
; 0000 012B       I2c_start(addr_oled);
	RCALL SUBOPT_0x4
;	*c -> R20,R21
;	n -> R18,R19
;	bytesOut -> R17
	LDI  R17,1
	RCALL SUBOPT_0x3
; 0000 012C       I2c_write(0x00);
; 0000 012D        while(n--) {
_0x2D:
	MOVW R30,R18
	__SUBWRN 18,19,1
	SBIW R30,0
	BREQ _0x2F
; 0000 012E         if(bytesOut >= WIRE_MAX) {
	CPI  R17,32
	BRLO _0x30
; 0000 012F          I2c_stop();
	RCALL _I2c_stop
; 0000 0130          I2c_start(addr_oled);
	RCALL SUBOPT_0x3
; 0000 0131          I2c_write(0x00);// Co = 0, D/C = 0
; 0000 0132           bytesOut = 1;
	LDI  R17,LOW(1)
; 0000 0133         }
; 0000 0134       I2c_write(*c++);
_0x30:
	MOVW R26,R20
	__ADDWRN 20,21,1
	LD   R26,X
	RCALL _I2c_write
; 0000 0135       bytesOut++;
	SUBI R17,-1
; 0000 0136     }
	RJMP _0x2D
_0x2F:
; 0000 0137       I2c_stop();
	RCALL _I2c_stop
; 0000 0138 }
	RJMP _0x20A0003
; .FEND
;
;void initDisplay()
; 0000 013B {
_initDisplay:
; .FSTART _initDisplay
; 0000 013C     memset(buffer,0,1024);
	RCALL SUBOPT_0x5
; 0000 013D     write_cmd1(0xAE);          // 0xAE // display off
	LDI  R26,LOW(174)
	RCALL _write_cmd1
; 0000 013E 
; 0000 013F     write_cmd1(0xD5);          // 0xD5 // set display clock division
	LDI  R26,LOW(213)
	RCALL _write_cmd1
; 0000 0140     write_cmd1(0x80);          // the suggested ratio 0x80
	LDI  R26,LOW(128)
	RCALL _write_cmd1
; 0000 0141 
; 0000 0142     write_cmd1(0xA8);          // 0xA8 set multiplex
	LDI  R26,LOW(168)
	RCALL _write_cmd1
; 0000 0143     write_cmd1(63);            // set height
	LDI  R26,LOW(63)
	RCALL _write_cmd1
; 0000 0144 
; 0000 0145 
; 0000 0146     write_cmd1(0xD3);          // set display offset
	LDI  R26,LOW(211)
	RCALL _write_cmd1
; 0000 0147     write_cmd1(0x00);           // no offset
	LDI  R26,LOW(0)
	RCALL _write_cmd1
; 0000 0148 
; 0000 0149     write_cmd1(0x40);            // line #0 setstartline
	LDI  R26,LOW(64)
	RCALL _write_cmd1
; 0000 014A     write_cmd1(0x8D);          // 0x8D // chargepump
	LDI  R26,LOW(141)
	RCALL _write_cmd1
; 0000 014B 
; 0000 014C     write_cmd1(0x14);    //?? 0x10
	LDI  R26,LOW(20)
	RCALL _write_cmd1
; 0000 014D 
; 0000 014E     write_cmd1(0x20);          // memory mode
	LDI  R26,LOW(32)
	RCALL _write_cmd1
; 0000 014F     write_cmd1(0x00);          // 0x0 act like ks0108
	LDI  R26,LOW(0)
	RCALL _write_cmd1
; 0000 0150     write_cmd1(0xA1);           // segremap
	LDI  R26,LOW(161)
	RCALL _write_cmd1
; 0000 0151     write_cmd1(0xC8);          // comscandec
	LDI  R26,LOW(200)
	RCALL _write_cmd1
; 0000 0152 
; 0000 0153     write_cmd1(0xDA);          // 0xDA set com pins
	LDI  R26,LOW(218)
	RCALL _write_cmd1
; 0000 0154     write_cmd1(0x12);
	LDI  R26,LOW(18)
	RCALL _write_cmd1
; 0000 0155 
; 0000 0156     write_cmd1(0x81);          // 0x81 // set contract
	LDI  R26,LOW(129)
	RCALL _write_cmd1
; 0000 0157     write_cmd1(0xCF);      //??  0x9F
	LDI  R26,LOW(207)
	RCALL _write_cmd1
; 0000 0158 
; 0000 0159     write_cmd1(0xD9);          // 0xd9 set pre-charge
	LDI  R26,LOW(217)
	RCALL _write_cmd1
; 0000 015A     write_cmd1(0xF1);         //0x22
	LDI  R26,LOW(241)
	RCALL _write_cmd1
; 0000 015B 
; 0000 015C     write_cmd1(0xDB);          // SSD1306_SETVCOMDETECT
	LDI  R26,LOW(219)
	RCALL _write_cmd1
; 0000 015D     write_cmd1(0x40);
	LDI  R26,LOW(64)
	RCALL _write_cmd1
; 0000 015E     write_cmd1(0xA4);          // 0xA4 // display all on resume
	LDI  R26,LOW(164)
	RCALL _write_cmd1
; 0000 015F     write_cmd1(0xA6);          // 0xA6 // normal display
	LDI  R26,LOW(166)
	RCALL _write_cmd1
; 0000 0160     write_cmd1(0x2E);          // deactivate scroll
	LDI  R26,LOW(46)
	RCALL _write_cmd1
; 0000 0161 
; 0000 0162     write_cmd1(0xAF);          // --turn on oled panel
	LDI  R26,LOW(175)
	RCALL _write_cmd1
; 0000 0163 
; 0000 0164 }
	RET
; .FEND
;  //// wire max =32
;void display()
; 0000 0167 {
_display:
; .FSTART _display
; 0000 0168 
; 0000 0169     int  count = WIDTH * ((HEIGHT + 7) / 8);
; 0000 016A     unsigned char *ptr   = buffer;
; 0000 016B     unsigned char bytesOut = 1;
; 0000 016C 
; 0000 016D     unsigned char dlist1[] = {
; 0000 016E      SSD1306_PAGEADDR,
; 0000 016F      0,                         // Page start address
; 0000 0170      0xFF,                      // Page end (not really, but works here)
; 0000 0171      SSD1306_COLUMNADDR,
; 0000 0172      0 };                       // Column start address
; 0000 0173     cmd_list(dlist1, sizeof(dlist1));
	SBIW R28,5
	LDI  R30,LOW(34)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	LDI  R30,LOW(255)
	STD  Y+2,R30
	LDI  R30,LOW(33)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	STD  Y+4,R30
	RCALL __SAVELOCR6
;	count -> R16,R17
;	*ptr -> R18,R19
;	bytesOut -> R21
;	dlist1 -> Y+6
	__GETWRN 16,17,1024
	__POINTWRM 18,19,_buffer
	LDI  R21,1
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _cmd_list
; 0000 0174     write_cmd1(WIDTH - 1);
	LDI  R26,LOW(127)
	RCALL _write_cmd1
; 0000 0175 
; 0000 0176 
; 0000 0177 
; 0000 0178    I2c_start(addr_oled);
	RCALL SUBOPT_0x6
; 0000 0179    I2c_write((unsigned)0x40);
; 0000 017A     while(count--) {
_0x31:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x33
; 0000 017B       if(bytesOut >= WIRE_MAX) {
	CPI  R21,32
	BRLO _0x34
; 0000 017C        I2c_stop();
	RCALL _I2c_stop
; 0000 017D          I2c_start(addr_oled);
	RCALL SUBOPT_0x6
; 0000 017E         I2c_write((unsigned)0x40);
; 0000 017F         bytesOut = 1;
	LDI  R21,LOW(1)
; 0000 0180       }
; 0000 0181       I2c_write(*ptr++);
_0x34:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R26,X
	RCALL _I2c_write
; 0000 0182       bytesOut++;
	SUBI R21,-1
; 0000 0183     }
	RJMP _0x31
_0x33:
; 0000 0184      I2c_stop();
	RCALL _I2c_stop
; 0000 0185 
; 0000 0186 
; 0000 0187 }
	RCALL __LOADLOCR6
	ADIW R28,11
	RET
; .FEND
;
;void drawpixel(int x, int y ){
; 0000 0189 void drawpixel(int x, int y ){
_drawpixel:
; .FSTART _drawpixel
; 0000 018A 
; 0000 018B   if((x >= 0) && (x <WIDTH) && (y >= 0) && (y < HEIGHT)) {
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	x -> R18,R19
;	y -> R16,R17
	TST  R19
	BRMI _0x36
	__CPWRN 18,19,128
	BRGE _0x36
	TST  R17
	BRMI _0x36
	__CPWRN 16,17,64
	BRLT _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 018C     buffer[x + (y/8)*WIDTH] |=  (1 << (y&7)); //
	RCALL SUBOPT_0x7
	RCALL __LSLW3
	RCALL __LSLW4
	ADD  R30,R18
	ADC  R31,R19
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R16
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 018D    }
; 0000 018E 
; 0000 018F 
; 0000 0190 
; 0000 0191 }
_0x35:
	RCALL __LOADLOCR4
_0x20A0004:
	ADIW R28,6
	RET
; .FEND
;// gui lenh laf 0x00
;// gui data 0x40
;void clear(){
; 0000 0194 void clear(){
_clear:
; .FSTART _clear
; 0000 0195     memset(buffer,0,1024);
	RCALL SUBOPT_0x5
; 0000 0196 }
	RET
; .FEND
;
;void draw1(int x, int y ){
; 0000 0198 void draw1(int x, int y ){
_draw1:
; .FSTART _draw1
; 0000 0199 int i,j;
; 0000 019A     for(i =x+3; i<x+6; i++){
	RCALL __SAVELOCR6
	MOVW R20,R26
;	x -> Y+6
;	y -> R20,R21
;	i -> R16,R17
;	j -> R18,R19
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,3
	MOVW R16,R30
_0x39:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,6
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x3A
; 0000 019B        for(j=y ;j<y+8 ;j++){
	MOVW R18,R20
_0x3C:
	RCALL SUBOPT_0x8
	BRGE _0x3D
; 0000 019C         drawpixel(i,j);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _drawpixel
; 0000 019D        }
	__ADDWRN 18,19,1
	RJMP _0x3C
_0x3D:
; 0000 019E     }
	__ADDWRN 16,17,1
	RJMP _0x39
_0x3A:
; 0000 019F }
	RJMP _0x20A0003
; .FEND
;
;void draw2(int x, int y ){
; 0000 01A1 void draw2(int x, int y ){
_draw2:
; .FSTART _draw2
; 0000 01A2 int j;
; 0000 01A3 
; 0000 01A4        for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x3F:
	RCALL SUBOPT_0x9
	BRGE _0x40
; 0000 01A5 
; 0000 01A6         drawpixel(j,x+1);
	RCALL SUBOPT_0xA
; 0000 01A7          drawpixel(j,x+6);
; 0000 01A8           drawpixel(j,x+7);
	RCALL SUBOPT_0xB
; 0000 01A9        }
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
; 0000 01AA 
; 0000 01AB 
; 0000 01AC          for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x42:
	RCALL SUBOPT_0xC
	BRGE _0x43
; 0000 01AD           drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 01AE        }
	__ADDWRN 16,17,1
	RJMP _0x42
_0x43:
; 0000 01AF 
; 0000 01B0         drawpixel(y+6,x+2);
	RCALL SUBOPT_0xE
; 0000 01B1         drawpixel(y+7,x+2);
; 0000 01B2         drawpixel(y+4,x+3);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 01B3         drawpixel(y+5,x+3);
; 0000 01B4         drawpixel(y+4,x+4);
	RCALL SUBOPT_0x11
; 0000 01B5         drawpixel(y+3,x+4);
	RCALL SUBOPT_0x11
; 0000 01B6         drawpixel(y+3,x+5);
	ADIW R26,5
	RCALL _drawpixel
; 0000 01B7         drawpixel(y+2,x+5);
	MOVW R30,R18
	ADIW R30,2
	RCALL SUBOPT_0x12
	RJMP _0x20A0002
; 0000 01B8 }
; .FEND
;
;void draw3(int x, int y ){
; 0000 01BA void draw3(int x, int y ){
_draw3:
; .FSTART _draw3
; 0000 01BB int j;
; 0000 01BC     for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x45:
	RCALL SUBOPT_0x9
	BRGE _0x46
; 0000 01BD 
; 0000 01BE         drawpixel(j,x+1);
	RCALL SUBOPT_0xA
; 0000 01BF          drawpixel(j,x+6);
; 0000 01C0        }
	__ADDWRN 16,17,1
	RJMP _0x45
_0x46:
; 0000 01C1         for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x48:
	RCALL SUBOPT_0xC
	BRGE _0x49
; 0000 01C2           drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 01C3            drawpixel(j,x+7);
	RCALL SUBOPT_0xB
; 0000 01C4        }
	__ADDWRN 16,17,1
	RJMP _0x48
_0x49:
; 0000 01C5         drawpixel(y+6,x+2);
	RCALL SUBOPT_0xE
; 0000 01C6         drawpixel(y+7,x+2);
; 0000 01C7 
; 0000 01C8         drawpixel(y+6,x+5);
	ADIW R30,6
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0000 01C9         drawpixel(y+7,x+5);
	RCALL _drawpixel
; 0000 01CA 
; 0000 01CB         drawpixel(y+4,x+3);
	MOVW R30,R18
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 01CC         drawpixel(y+5,x+3);
; 0000 01CD         drawpixel(y+4,x+4);
	RCALL SUBOPT_0x14
; 0000 01CE         drawpixel(y+5,x+4);
	RCALL SUBOPT_0x15
	RJMP _0x20A0002
; 0000 01CF }
; .FEND
;
;void draw4(int x, int y ){
; 0000 01D1 void draw4(int x, int y ){
_draw4:
; .FSTART _draw4
; 0000 01D2 int i,j;
; 0000 01D3      for(j=y ;j<y+8 ;j++){
	RCALL __SAVELOCR6
	MOVW R20,R26
;	x -> Y+6
;	y -> R20,R21
;	i -> R16,R17
;	j -> R18,R19
	MOVW R18,R20
_0x4B:
	RCALL SUBOPT_0x8
	BRGE _0x4C
; 0000 01D4          drawpixel(j,x+6);
	RCALL SUBOPT_0x16
	ADIW R26,6
	RCALL _drawpixel
; 0000 01D5             drawpixel(j,x+5);
	RCALL SUBOPT_0x16
	ADIW R26,5
	RCALL _drawpixel
; 0000 01D6      }
	__ADDWRN 18,19,1
	RJMP _0x4B
_0x4C:
; 0000 01D7       for(i =x+0; i<x+8; i++){
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,0
	MOVW R16,R30
_0x4E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,8
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x4F
; 0000 01D8         drawpixel(y+6,i);
	MOVW R30,R20
	ADIW R30,6
	RCALL SUBOPT_0x17
; 0000 01D9         drawpixel(y+5,i);
	MOVW R30,R20
	ADIW R30,5
	RCALL SUBOPT_0x17
; 0000 01DA       }
	__ADDWRN 16,17,1
	RJMP _0x4E
_0x4F:
; 0000 01DB       for(i =x+1; i<x+5; i++){
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	MOVW R16,R30
_0x51:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,5
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x52
; 0000 01DC         drawpixel(y+(5-(i-x)),i);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R20
	ADC  R31,R21
	RCALL SUBOPT_0x17
; 0000 01DD 
; 0000 01DE       }
	__ADDWRN 16,17,1
	RJMP _0x51
_0x52:
; 0000 01DF }
	RJMP _0x20A0003
; .FEND
;
;void draw6(int x, int y ){
; 0000 01E1 void draw6(int x, int y ){
_draw6:
; .FSTART _draw6
; 0000 01E2 int j;
; 0000 01E3      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x54:
	RCALL SUBOPT_0x9
	BRGE _0x55
; 0000 01E4          drawpixel(j,x+6);
	RCALL SUBOPT_0x18
; 0000 01E5             drawpixel(j,x+1);
; 0000 01E6      }
	__ADDWRN 16,17,1
	RJMP _0x54
_0x55:
; 0000 01E7        for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x57:
	RCALL SUBOPT_0xC
	BRGE _0x58
; 0000 01E8          drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 01E9             drawpixel(j,x+3);
	RCALL SUBOPT_0x19
; 0000 01EA              drawpixel(j,x+7);
; 0000 01EB      }
	__ADDWRN 16,17,1
	RJMP _0x57
_0x58:
; 0000 01EC 
; 0000 01ED       drawpixel(y+0,x+2);
	RCALL SUBOPT_0x1A
	ADIW R26,2
	RCALL _drawpixel
; 0000 01EE         drawpixel(y+0,x+3);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0000 01EF          drawpixel(y+1,x+2);
; 0000 01F0         drawpixel(y+1,x+3);
; 0000 01F1       drawpixel(y+0,x+4);
	ADIW R30,0
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x1C
; 0000 01F2         drawpixel(y+0,x+5);
	RCALL SUBOPT_0x1D
; 0000 01F3          drawpixel(y+1,x+4);
	RCALL SUBOPT_0x1E
; 0000 01F4         drawpixel(y+1,x+5);
	RCALL SUBOPT_0x1F
; 0000 01F5         drawpixel(y+6,x+4);
	RCALL SUBOPT_0x20
; 0000 01F6         drawpixel(y+6,x+5);
	RCALL SUBOPT_0x21
; 0000 01F7          drawpixel(y+7,x+4);
	RCALL SUBOPT_0x13
; 0000 01F8         drawpixel(y+7,x+5);
	RJMP _0x20A0002
; 0000 01F9 
; 0000 01FA 
; 0000 01FB }
; .FEND
;
;
;void draw5(int x, int y ){
; 0000 01FE void draw5(int x, int y ){
_draw5:
; .FSTART _draw5
; 0000 01FF int j;
; 0000 0200      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x5A:
	RCALL SUBOPT_0x9
	BRGE _0x5B
; 0000 0201          drawpixel(j,x+6);
	RCALL SUBOPT_0x18
; 0000 0202             drawpixel(j,x+1);
; 0000 0203      }
	__ADDWRN 16,17,1
	RJMP _0x5A
_0x5B:
; 0000 0204        for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x5D:
	RCALL SUBOPT_0xC
	BRGE _0x5E
; 0000 0205          drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 0206             drawpixel(j,x+3);
	RCALL SUBOPT_0x19
; 0000 0207              drawpixel(j,x+7);
; 0000 0208      }
	__ADDWRN 16,17,1
	RJMP _0x5D
_0x5E:
; 0000 0209 
; 0000 020A       drawpixel(y+0,x+2);
	RCALL SUBOPT_0x1A
	ADIW R26,2
	RCALL _drawpixel
; 0000 020B         drawpixel(y+0,x+3);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0000 020C          drawpixel(y+1,x+2);
; 0000 020D         drawpixel(y+1,x+3);
; 0000 020E         drawpixel(y+6,x+4);
	ADIW R30,6
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x20
; 0000 020F         drawpixel(y+6,x+5);
	RCALL SUBOPT_0x21
; 0000 0210          drawpixel(y+7,x+4);
	RCALL SUBOPT_0x13
; 0000 0211         drawpixel(y+7,x+5);
	RCALL _drawpixel
; 0000 0212           drawpixel(y,x);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R20
	RCALL SUBOPT_0x22
; 0000 0213           drawpixel(y+1,x);
	RJMP _0x20A0002
; 0000 0214 }
; .FEND
;
;void draw7(int x, int y ){
; 0000 0216 void draw7(int x, int y ){
_draw7:
; .FSTART _draw7
; 0000 0217 int j;
; 0000 0218      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x60:
	RCALL SUBOPT_0x9
	BRGE _0x61
; 0000 0219          drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 021A            }
	__ADDWRN 16,17,1
	RJMP _0x60
_0x61:
; 0000 021B 
; 0000 021C       drawpixel(y+0,x+1);
	RCALL SUBOPT_0x1A
	ADIW R26,1
	RCALL SUBOPT_0x23
; 0000 021D        drawpixel(y+7,x+1);
	ADIW R26,1
	RCALL SUBOPT_0x24
; 0000 021E        drawpixel(y+6,x+3);
	ADIW R26,3
	RCALL SUBOPT_0x22
; 0000 021F          drawpixel(y+1,x+1);
	ADIW R26,1
	RCALL _drawpixel
; 0000 0220         drawpixel(y+4,x+4);
	MOVW R30,R18
	RCALL SUBOPT_0xF
	ADIW R26,4
	RCALL _drawpixel
; 0000 0221         drawpixel(y+4,x+5);
	MOVW R30,R18
	RCALL SUBOPT_0xF
	ADIW R26,5
	RCALL _drawpixel
; 0000 0222          drawpixel(y+5,x+4);
	MOVW R30,R18
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RCALL SUBOPT_0x14
; 0000 0223         drawpixel(y+5,x+5);
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x24
; 0000 0224           drawpixel(y+6,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x24
; 0000 0225         drawpixel(y+6,x+3);
	ADIW R26,3
	RCALL SUBOPT_0x23
; 0000 0226          drawpixel(y+7,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x23
; 0000 0227         drawpixel(y+7,x+3);
	ADIW R26,3
	RCALL _drawpixel
; 0000 0228          drawpixel(y+4,x+6);
	MOVW R30,R18
	RCALL SUBOPT_0xF
	ADIW R26,6
	RCALL _drawpixel
; 0000 0229         drawpixel(y+4,x+7);
	MOVW R30,R18
	RCALL SUBOPT_0xF
	ADIW R26,7
	RCALL SUBOPT_0x25
; 0000 022A          drawpixel(y+3,x+6);
	ADIW R26,6
	RCALL SUBOPT_0x25
; 0000 022B         drawpixel(y+3,x+7);
	ADIW R26,7
	RJMP _0x20A0002
; 0000 022C }
; .FEND
;
;void draw8(int x, int y ){
; 0000 022E void draw8(int x, int y ){
_draw8:
; .FSTART _draw8
; 0000 022F int j;
; 0000 0230      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x63:
	RCALL SUBOPT_0x9
	BRGE _0x64
; 0000 0231          drawpixel(j,x+6);
	RCALL SUBOPT_0x18
; 0000 0232             drawpixel(j,x+1);
; 0000 0233      }
	__ADDWRN 16,17,1
	RJMP _0x63
_0x64:
; 0000 0234        for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x66:
	RCALL SUBOPT_0xC
	BRGE _0x67
; 0000 0235             drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 0236             drawpixel(j,x+3);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,3
	RCALL _drawpixel
; 0000 0237               drawpixel(j,x+4);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,4
	RCALL _drawpixel
; 0000 0238              drawpixel(j,x+7);
	RCALL SUBOPT_0xB
; 0000 0239      }
	__ADDWRN 16,17,1
	RJMP _0x66
_0x67:
; 0000 023A 
; 0000 023B       drawpixel(y+0,x+2);
	RCALL SUBOPT_0x1A
	ADIW R26,2
	RCALL SUBOPT_0x22
; 0000 023C        // drawpixel(y+0,x+3);
; 0000 023D          drawpixel(y+1,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x22
; 0000 023E         drawpixel(y+1,x+3);
	ADIW R26,3
	RCALL SUBOPT_0x1C
; 0000 023F        //drawpixel(y+0,x+4);
; 0000 0240         drawpixel(y+0,x+5);
	RCALL SUBOPT_0x1D
; 0000 0241          drawpixel(y+1,x+4);
	RCALL SUBOPT_0x1E
; 0000 0242         drawpixel(y+1,x+5);
	RCALL SUBOPT_0x1F
; 0000 0243         drawpixel(y+6,x+4);
	RCALL SUBOPT_0x20
; 0000 0244         drawpixel(y+6,x+5);
	RCALL SUBOPT_0x13
; 0000 0245        //  drawpixel(y+7,x+4);
; 0000 0246         drawpixel(y+7,x+5);
	RCALL SUBOPT_0x24
; 0000 0247 
; 0000 0248         drawpixel(y+6,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x24
; 0000 0249         drawpixel(y+6,x+3);
	ADIW R26,3
	RCALL SUBOPT_0x23
; 0000 024A          drawpixel(y+7,x+2);
	ADIW R26,2
	RJMP _0x20A0002
; 0000 024B        // drawpixel(y+7,x+3);
; 0000 024C }
; .FEND
;
;void draw9(int x, int y ){
; 0000 024E void draw9(int x, int y ){
_draw9:
; .FSTART _draw9
; 0000 024F int j;
; 0000 0250      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x69:
	RCALL SUBOPT_0x9
	BRGE _0x6A
; 0000 0251          drawpixel(j,x+6);
	RCALL SUBOPT_0x18
; 0000 0252             drawpixel(j,x+1);
; 0000 0253      }
	__ADDWRN 16,17,1
	RJMP _0x69
_0x6A:
; 0000 0254        for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x6C:
	RCALL SUBOPT_0xC
	BRGE _0x6D
; 0000 0255          drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 0256             drawpixel(j,x+3);
	RCALL SUBOPT_0x19
; 0000 0257              drawpixel(j,x+7);
; 0000 0258      }
	__ADDWRN 16,17,1
	RJMP _0x6C
_0x6D:
; 0000 0259 
; 0000 025A         drawpixel(y+0,x+2);
	RCALL SUBOPT_0x1A
	ADIW R26,2
	RCALL _drawpixel
; 0000 025B         drawpixel(y+0,x+3);
	RCALL SUBOPT_0x1A
	ADIW R26,3
	RCALL SUBOPT_0x22
; 0000 025C          drawpixel(y+1,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x22
; 0000 025D         drawpixel(y+1,x+3);
	ADIW R26,3
	RJMP _0x20A0001
; 0000 025E         drawpixel(y+6,x+4);
; 0000 025F         drawpixel(y+6,x+5);
; 0000 0260         drawpixel(y+7,x+4);
; 0000 0261         drawpixel(y+7,x+5);
; 0000 0262         drawpixel(y+6,x+2);
; 0000 0263         drawpixel(y+6,x+3);
; 0000 0264         drawpixel(y+7,x+2);
; 0000 0265         drawpixel(y+7,x+3);
; 0000 0266 
; 0000 0267 }
; .FEND
;
;void draw0(int x, int y ){
; 0000 0269 void draw0(int x, int y ){
_draw0:
; .FSTART _draw0
; 0000 026A int j;
; 0000 026B      for(j=y ;j<y+8 ;j++){
	RCALL SUBOPT_0x4
;	x -> R20,R21
;	y -> R18,R19
;	j -> R16,R17
	MOVW R16,R18
_0x6F:
	RCALL SUBOPT_0x9
	BRGE _0x70
; 0000 026C          drawpixel(j,x+6);
	RCALL SUBOPT_0x18
; 0000 026D             drawpixel(j,x+1);
; 0000 026E      }
	__ADDWRN 16,17,1
	RJMP _0x6F
_0x70:
; 0000 026F        for(j=y+2 ;j<y+6 ;j++){
	MOVW R30,R18
	ADIW R30,2
	MOVW R16,R30
_0x72:
	RCALL SUBOPT_0xC
	BRGE _0x73
; 0000 0270          drawpixel(j,x);
	RCALL SUBOPT_0xD
; 0000 0271           //  drawpixel(j,x+3);
; 0000 0272              drawpixel(j,x+7);
	RCALL SUBOPT_0xB
; 0000 0273      }
	__ADDWRN 16,17,1
	RJMP _0x72
_0x73:
; 0000 0274 
; 0000 0275         drawpixel(y+0,x+2);
	RCALL SUBOPT_0x1A
	ADIW R26,2
	RCALL _drawpixel
; 0000 0276         drawpixel(y+0,x+3);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0000 0277          drawpixel(y+1,x+2);
; 0000 0278         drawpixel(y+1,x+3);
; 0000 0279         drawpixel(y+0,x+4);
	ADIW R30,0
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x1C
; 0000 027A         drawpixel(y+0,x+5);
	RCALL SUBOPT_0x1D
; 0000 027B         drawpixel(y+1,x+4);
	RCALL SUBOPT_0x1E
; 0000 027C         drawpixel(y+1,x+5);
_0x20A0001:
	RCALL _drawpixel
; 0000 027D         drawpixel(y+6,x+4);
	MOVW R30,R18
	ADIW R30,6
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x20
; 0000 027E         drawpixel(y+6,x+5);
	RCALL SUBOPT_0x21
; 0000 027F         drawpixel(y+7,x+4);
	RCALL SUBOPT_0x13
; 0000 0280         drawpixel(y+7,x+5);
	RCALL SUBOPT_0x24
; 0000 0281         drawpixel(y+6,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x24
; 0000 0282         drawpixel(y+6,x+3);
	ADIW R26,3
	RCALL SUBOPT_0x23
; 0000 0283         drawpixel(y+7,x+2);
	ADIW R26,2
	RCALL SUBOPT_0x23
; 0000 0284         drawpixel(y+7,x+3);
	ADIW R26,3
_0x20A0002:
	RCALL _drawpixel
; 0000 0285 
; 0000 0286 }
_0x20A0003:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;//void drawH(int x, int y ){
;// int i, j;
;//         for(i =x; i<x+8; i++){
;//            drawpixel(y,i);
;//            drawpixel(y+1,i);
;//            drawpixel(y+6,i);
;//            drawpixel(y+7,i);
;//         }
;//
;//         for(j=y+2 ;j<y+6 ;j++){
;//         drawpixel(j,x+3);
;//          //  drawpixel(j,x+3);
;//             drawpixel(j,x+4);
;//     }
;//}
;//
;//void drawU(int x, int y ){
;// int i, j;
;//         for(i =x; i<x+6; i++){
;//            drawpixel(y,i);
;//            drawpixel(y+1,i);
;//            drawpixel(y+6,i);
;//           // drawpixel(y+7,i);
;//         }
;//          for(i =x; i<x+8; i++){
;//
;//            drawpixel(y+7,i);
;//         }
;//
;//         for(j=y+2 ;j<y+6 ;j++){
;//           drawpixel(j,x+6);
;//
;//           drawpixel(j,x+7);
;//     }
;//}
;//
;//void drawV(int x, int y ){
;// int i, j;
;//         for(i =x; i<x+6; i++){
;//            drawpixel(y,i);
;//            drawpixel(y+1,i);
;//            drawpixel(y+6,i);
;//            drawpixel(y+7,i);
;//         }
;//
;//
;//         for(j=y+2 ;j<y+6 ;j++){
;//           drawpixel(j,x+6);
;//
;//           drawpixel(j,x+7);
;//     }
;//}
;//
;//void drawP(int x, int y ){
;// int i, j;
;//         for(i =x; i<x+8; i++){
;//            drawpixel(y,i);
;//            drawpixel(y+1,i);
;//
;//         }
;//
;//
;//         for(j=y+2 ;j<y+5 ;j++){
;//           drawpixel(j,x+0);
;//
;//           drawpixel(j,x+3);
;//         }
;//         drawpixel(y+5,x+1);
;//         drawpixel(y+5,x+2);
;//
;//}
;//
;//
;//void drawR(int x, int y ){
;// int i, j;
;//         for(i =x; i<x+8; i++){
;//            drawpixel(y,i);
;//            drawpixel(y+1,i);
;//
;//         }
;//
;//
;//         for(j=y+2 ;j<y+5 ;j++){
;//           drawpixel(j,x+0);
;//
;//           drawpixel(j,x+3);
;//         }
;//         drawpixel(y+5,x+1);
;//         drawpixel(y+5,x+2);
;//          drawpixel(y+5,x+6);
;//         drawpixel(y+5,x+7);
;//
;//          drawpixel(y+5,x+5);
;//          drawpixel(y+6,x+7);
;//
;//          drawpixel(y+4,x+3);
;//          drawpixel(y+5,x+4);
;//}
;//
;//
;//void drawS(int x, int y ){
;//
;//        drawpixel(y+3,x+0);
;//         drawpixel(y+4,x+0);
;//          drawpixel(y+5,x+0);
;//
;//        //drawpixel(y+1,x+1);
;//        drawpixel(y+2,x+1);
;//        drawpixel(y+3,x+1);
;//        drawpixel(y+5,x+1);
;//        drawpixel(y+6,x+1);
;//
;//        //drawpixel(y+1,x+2);
;//        drawpixel(y+2,x+2);
;//        drawpixel(y+6,x+2);
;//
;//        drawpixel(y+3,x+3);
;//        drawpixel(y+4,x+4);
;//
;//        drawpixel(y+1,x+5);
;//        drawpixel(y+5,x+5);
;//       // drawpixel(y+6,x+5);
;//       //  drawpixel(y+1,x+1);
;//
;//        drawpixel(y+2,x+6);
;//        drawpixel(y+1,x+6);
;//        drawpixel(y+4,x+6);
;//        drawpixel(y+5,x+6);
;//       // drawpixel(y+6,x+6);
;//
;//        drawpixel(y+3,x+7);
;//         drawpixel(y+4,x+7);
;//          drawpixel(y+2,x+7);
;//}
;//void drawC(int x, int y ){
;//        int j;
;//        for (j =y+3;j<y+6;j++){
;//            drawpixel(j,x+0);
;//            drawpixel(j,x+7);
;//
;//        }
;//
;//        drawpixel(y+2,x+1);
;//        drawpixel(y+6,x+1);
;//
;//
;//        drawpixel(y+2,x+2);
;//        drawpixel(y+1,x+2);
;//
;//        drawpixel(y+1,x+3);
;//        drawpixel(y+2,x+3);
;//         drawpixel(y+1,x+4);
;//        drawpixel(y+2,x+4);
;//
;//      drawpixel(y+1,x+5);
;//        drawpixel(y+2,x+5);
;//
;//        drawpixel(y+2,x+6);
;//        drawpixel(y+6,x+6);
;//
;//
;//}
;//
;//
;//
;//void drawTwoPoint(int x, int y ){
;//        drawpixel(y+1,x+7);
;//        drawpixel(y+2,x+7);
;//
;//        drawpixel(y+1,x+6);
;//        drawpixel(y+2,x+6);
;//        drawpixel(y+1,x+0);
;//        drawpixel(y+2,x+0);
;//
;//        drawpixel(y+1,x+1);
;//        drawpixel(y+2,x+1);
;//
;//}
;
;
;
;void drawBitmap(int x, int y, unsigned char bitmap[], int w, int  h) {
; 0000 033D void drawBitmap(int x, int y, unsigned char bitmap[], int w, int  h) {
_drawBitmap:
; .FSTART _drawBitmap
; 0000 033E    int i, j;
; 0000 033F    int byteWidth= (w+7)/8;
; 0000 0340    int  byte = 0;
; 0000 0341   for ( j = 0; j < h; j++) {
	ST   -Y,R27
	ST   -Y,R26
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR6
;	x -> Y+16
;	y -> Y+14
;	bitmap -> Y+12
;	w -> Y+10
;	h -> Y+8
;	i -> R16,R17
;	j -> R18,R19
;	byteWidth -> R20,R21
;	byte -> Y+6
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,7
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL __DIVW21
	MOVW R20,R30
	__GETWRN 18,19,0
_0x75:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x76
; 0000 0342     for ( i = 0; i < w; i++) {
	__GETWRN 16,17,0
_0x78:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x79
; 0000 0343 
; 0000 0344           if (i & 7)
	MOV  R30,R16
	ANDI R30,LOW(0x7)
	BREQ _0x7A
; 0000 0345           byte <<= 1;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	RJMP _0x83
; 0000 0346           else
_0x7A:
; 0000 0347           byte = bitmap[j * byteWidth + i / 8];
	MOVW R30,R20
	MOVW R26,R18
	RCALL __MULW12
	MOVW R22,R30
	RCALL SUBOPT_0x7
	ADD  R30,R22
	ADC  R31,R23
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
_0x83:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0348          if(byte & 0x80){
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x7C
; 0000 0349             drawpixel(x + i,y+j);
	MOVW R30,R16
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL _drawpixel
; 0000 034A          }
; 0000 034B 
; 0000 034C 
; 0000 034D     }
_0x7C:
	__ADDWRN 16,17,1
	RJMP _0x78
_0x79:
; 0000 034E   }
	__ADDWRN 18,19,1
	RJMP _0x75
_0x76:
; 0000 034F 
; 0000 0350 }
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
;
;void drawImage(unsigned char bitmap[],int  LOGO_HEIGHT,int  LOGO_WIDTH){
; 0000 0352 void drawImage(unsigned char bitmap[],int  LOGO_HEIGHT,int  LOGO_WIDTH){
_drawImage:
; .FSTART _drawImage
; 0000 0353     drawBitmap(
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
;	bitmap -> R20,R21
;	LOGO_HEIGHT -> R18,R19
;	LOGO_WIDTH -> R16,R17
; 0000 0354     (WIDTH  - LOGO_WIDTH ) / 2,
; 0000 0355     (HEIGHT - LOGO_HEIGHT) / 2,
; 0000 0356     bitmap, LOGO_WIDTH, LOGO_HEIGHT);
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	SUB  R30,R16
	SBC  R31,R17
	RCALL SUBOPT_0x26
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	SUB  R30,R18
	SBC  R31,R19
	RCALL SUBOPT_0x26
	ST   -Y,R21
	ST   -Y,R20
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _drawBitmap
; 0000 0357 }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;
;void main(void)
; 0000 035A {
_main:
; .FSTART _main
; 0000 035B   char temstr[5];
; 0000 035C   funtion[0] =draw0;
	SBIW R28,5
;	temstr -> Y+0
	LDI  R30,LOW(_draw0)
	LDI  R31,HIGH(_draw0)
	STS  _funtion,R30
	STS  _funtion+1,R31
; 0000 035D   funtion[1] =draw1;
	__POINTW2MN _funtion,2
	LDI  R30,LOW(_draw1)
	LDI  R31,HIGH(_draw1)
	ST   X+,R30
	ST   X,R31
; 0000 035E   funtion[2] =draw2;
	__POINTW2MN _funtion,4
	LDI  R30,LOW(_draw2)
	LDI  R31,HIGH(_draw2)
	ST   X+,R30
	ST   X,R31
; 0000 035F   funtion[3] =draw3;
	__POINTW2MN _funtion,6
	LDI  R30,LOW(_draw3)
	LDI  R31,HIGH(_draw3)
	ST   X+,R30
	ST   X,R31
; 0000 0360   funtion[4] =draw4;
	__POINTW2MN _funtion,8
	LDI  R30,LOW(_draw4)
	LDI  R31,HIGH(_draw4)
	ST   X+,R30
	ST   X,R31
; 0000 0361   funtion[5] =draw5;
	__POINTW2MN _funtion,10
	LDI  R30,LOW(_draw5)
	LDI  R31,HIGH(_draw5)
	ST   X+,R30
	ST   X,R31
; 0000 0362   funtion[6] =draw6;
	__POINTW2MN _funtion,12
	LDI  R30,LOW(_draw6)
	LDI  R31,HIGH(_draw6)
	ST   X+,R30
	ST   X,R31
; 0000 0363   funtion[7] =draw7;
	__POINTW2MN _funtion,14
	LDI  R30,LOW(_draw7)
	LDI  R31,HIGH(_draw7)
	ST   X+,R30
	ST   X,R31
; 0000 0364   funtion[8] =draw8;
	__POINTW2MN _funtion,16
	LDI  R30,LOW(_draw8)
	LDI  R31,HIGH(_draw8)
	ST   X+,R30
	ST   X,R31
; 0000 0365   funtion[9] =draw9;
	__POINTW2MN _funtion,18
	LDI  R30,LOW(_draw9)
	LDI  R31,HIGH(_draw9)
	ST   X+,R30
	ST   X,R31
; 0000 0366   uart_Init();
	RCALL _uart_Init
; 0000 0367    #asm("sei");
	SEI
; 0000 0368   I2c_init();
	RCALL _I2c_init
; 0000 0369   initDisplay();
	RCALL _initDisplay
; 0000 036A   while (1)
_0x7D:
; 0000 036B       {
; 0000 036C        clear();
	RCALL _clear
; 0000 036D       if(!flag){
	TST  R3
	BRNE _0x80
; 0000 036E       drawImage(logo_bmp,67,45);
	LDI  R30,LOW(_logo_bmp)
	LDI  R31,HIGH(_logo_bmp)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(45)
	LDI  R27,0
	RCALL _drawImage
; 0000 036F 
; 0000 0370       }else{
	RJMP _0x81
_0x80:
; 0000 0371        memset(temstr,0,5);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _memset
; 0000 0372        itoa(temp,temstr);
	ST   -Y,R6
	ST   -Y,R5
	MOVW R26,R28
	ADIW R26,2
	RCALL _itoa
; 0000 0373        funtion[temstr[0]-48](30,20);
	LD   R30,Y
	RCALL SUBOPT_0x27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x28
	LDI  R26,LOW(20)
	LDI  R27,0
	POP  R30
	POP  R31
	ICALL
; 0000 0374        funtion[temstr[1]-48](30,30);
	LDD  R30,Y+1
	RCALL SUBOPT_0x27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x28
	LDI  R26,LOW(30)
	LDI  R27,0
	POP  R30
	POP  R31
	ICALL
; 0000 0375        // flag=0;
; 0000 0376      }
_0x81:
; 0000 0377          display();
	RCALL _display
; 0000 0378       }
	RJMP _0x7D
; 0000 0379 }
_0x82:
	RJMP _0x82
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_logo_bmp:
	.BYTE 0x192
_funtion:
	.BYTE 0x14
_buffer:
	.BYTE 0x400
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	STS  187,R16
	LDI  R30,LOW(132)
	STS  188,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(120)
	RCALL _I2c_start
	LDI  R26,LOW(0)
	RJMP _I2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1024)
	LDI  R27,HIGH(1024)
	RJMP _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(120)
	RCALL _I2c_start
	LDI  R26,LOW(64)
	RJMP _I2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOVW R26,R16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOVW R30,R20
	ADIW R30,8
	CP   R18,R30
	CPC  R19,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9:
	MOVW R30,R18
	ADIW R30,8
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,1
	RCALL _drawpixel
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,6
	RJMP _drawpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,7
	RJMP _drawpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	MOVW R30,R18
	ADIW R30,6
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xD:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	RJMP _drawpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	MOVW R30,R18
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,2
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,2
	RCALL _drawpixel
	MOVW R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xF:
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	ADIW R26,3
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,3
	RCALL _drawpixel
	MOVW R30,R18
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	ADIW R26,4
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x13:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,7
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ADIW R26,4
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R19
	ST   -Y,R18
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RJMP _drawpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x18:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,6
	RCALL _drawpixel
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,1
	RJMP _drawpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R20
	ADIW R26,3
	RCALL _drawpixel
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1A:
	MOVW R30,R18
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1B:
	ADIW R26,3
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,2
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	ADIW R26,3
	RCALL _drawpixel
	MOVW R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,6
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,6
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,7
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x22:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x23:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x24:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	RCALL _drawpixel
	MOVW R30,R18
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(_funtion)
	LDI  R27,HIGH(_funtion)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
