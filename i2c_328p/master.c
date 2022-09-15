#include <mega328p.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define     ADC0        0
#define		ADC1		1
#define		ADC2		2
#define		ADC3		3
#define		ADC4		4
#define		ADC5		5

#define WIDTH 128
#define HEIGHT 64
#define WIRE_MAX 32 
#define addr_oled 0x78
#define TW_START 0x08 // start 
#define  TW_REP_START  0x10    // repeat start 
#define  TW_MT_SLA_ACK 0x18   // truyen slave addr de ghi co ack   
#define  TW_MT_SLA_NACK 0x20 //  truyen slave addr de ghi  ko co ack 
#define  TW_MR_SLA_ACK 0x40   // truyen slave addr de doc co ack 
#define  TW_MT_DATA_ACK 0x28 // gui dl co ack 
#define  TW_MT_DATA_NACK 0x30  // nhan dl khong co ack
#define SSD1306_COLUMNADDR          0x21 ///< See datasheet
#define SSD1306_PAGEADDR            0x22        ///< See datasheet
char data;
char flag =0 ; 
int temp;           
unsigned char logo_bmp[] =
{ 0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x1f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3e,0x6f,0xe4,0xf0,
  0x00,0x00,0x3e,0xa7,0x20,0xf0,
  0x00,0x40,0x3e,0x0b,0x21,0xf0,
  0x01,0xf0,0x3e,0x83,0x20,0xf0,
  0x00,0xe0,0x3e,0x53,0x64,0xf0,
  0x00,0xe0,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xef,0xf0,
  0x00,0x00,0x3f,0xfc,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0x5f,0xf0,
  0x00,0x00,0x3f,0xef,0xbf,0xf0,
  0x00,0x00,0x3f,0xff,0xbf,0xf0,
  0x00,0x00,0x3f,0x73,0xef,0xf0,
  0x00,0x00,0x3d,0xdb,0xff,0xf0,
  0x00,0x00,0x3b,0x7e,0xff,0xf0,
  0x00,0x00,0x0d,0xfd,0xff,0xf0,
  0x00,0x00,0x1b,0xef,0xff,0xf0,
  0x00,0x00,0x6f,0xfb,0xff,0xf0,
  0x00,0x00,0xbf,0xdf,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xaf,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0x5f,0xff,0xf0,
  0x00,0x00,0x3f,0xbf,0xff,0xf0,
  0x00,0x00,0x3e,0xff,0xff,0xf0,
  0x00,0x00,0xef,0xef,0xff,0xf0,
  0x00,0x00,0xfc,0xff,0xff,0xf0,
  0x00,0x01,0x3f,0xff,0xff,0xf0,
  0x00,0x14,0x39,0xff,0xff,0xf0,
  0x00,0x18,0x3b,0xff,0xff,0xf0,
  0x00,0x30,0x37,0xff,0xff,0xf0,
  0x00,0x10,0x37,0xff,0xff,0xf0,
  0x00,0x00,0x2f,0xff,0xff,0xf0,
  0x00,0x00,0x0f,0xff,0xff,0xf0,
  0x00,0x00,0x1f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x10,0x3f,0xff,0xff,0xf0,
  0x00,0x30,0x3f,0xff,0xff,0xf0,
  0x00,0x38,0x3f,0xff,0xff,0xf0,
  0x00,0x18,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x01,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0xef,0xff,0xff,0xf0,
  0x00,0x00,0xef,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x3f,0xff,0xff,0xf0,
  0x00,0x00,0x1f,0xff,0xff,0xf0,
  0x3f,0xff,0xdf,0xff,0xff,0xf0,
  0x3f,0xdf,0xff,0xff,0xff,0xf0,
  0x3f,0xdf,0xff,0xff,0xff,0xf0,
  0x30,0x88,0x13,0x02,0x04,0x70,
  0x30,0x88,0x13,0x02,0x04,0x70,
  0x30,0x89,0x03,0x10,0x04,0x70,
  0x30,0x89,0x83,0x10,0x04,0x70,
  0x30,0x00,0x13,0x02,0x00,0x30,
  0x30,0x20,0x13,0x02,0x01,0x30,
  0x3b,0xac,0xb7,0xea,0xcf,0x70,
  0x3f,0xff,0xff,0xff,0xff,0xf0,
  0x3f,0xff,0xff,0xff,0xff,0xf0,
  0x00,0x00,0x00,0x00,0x00,0x00,

};
//char mess[10];
void(*funtion[10])(int,int);  

unsigned char buffer[WIDTH*HEIGHT/8]; // 128 cot , 64 hang => co can 1024 byte bieu dien het man hinh 

void ADC_init(unsigned char input_channel) {

	ADCSRA |= (1 << ADEN);
	
	// The voltage reference is selected by the two bits REFS1 and REFS0 in the ADMUX register
	// 0 0	< AREF >
	// 0 1	< AVCC with external capacitor at AREF pin >
	// 1 1	< Internal 2.56V voltage reference with capacitor at AREF pin >
	ADMUX |= (1 << REFS0) | (1 << REFS1);
	// Set the result is right adjusted
	// Set this bit to one if use result as left adjusted
	ADMUX |= (0 << ADLAR);
	// Select input channel for AD_Converter: AD0 - AD7
	ADMUX |= input_channel;
	// ADPS[2:0] determine the division factor between the XTAL frequency and the input clock to the ADC
	// Required input clock frequency: 50kHz -> 200kHz
	// 16MHz / 128 ~ 125kHz
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
}


unsigned int ADC_read() {
	unsigned int res = 0;
	ADCSRA |= (1 << ADSC);
	while(ADCSRA & (1 << ADSC));

	res = ADCL;
	res |= (ADCH << 8);
	
	return res;
}

int ADC_convert(unsigned int ADC) {

	float temperature = ( ADC * 0.11);

	return (int)temperature;
}

void uart_Init(){
  UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x67;
}
interrupt [USART_RXC]void usart_receive_isr (void)
{

 data = UDR0; 
 flag =1; 
 if(data=='G'){
    int adc_res = 0;
	ADC_init(ADC0);

//	while (1) {
		adc_res = ADC_read();
		temp = ADC_convert(adc_res);  
        UDR0 = temp;
        data =0;  
       
//	}  
 }  
} 
void read_Uart(){
}

void I2c_init(void)
{
     TWSR = 0x00; 
     TWBR = 72 ;
}



unsigned char I2c_start(unsigned char address)
{
    char   twst;

	// send START condition
	TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);

	// wait until transmission completed
	while(!(TWCR & (1<<TWINT)));

	// check value of TWI Status Register. Mask prescaler bits.
	twst = TWSR & 0xF8;
	if ( (twst != TW_START) && (twst != TW_REP_START)) return 1;

	// send device address
	TWDR = address;
	TWCR = (1<<TWINT) | (1<<TWEN);

	// wail until transmission completed and ACK/NACK has been received
	while(!(TWCR & (1<<TWINT)));

	// check value of TWI Status Register. Mask prescaler bits.
	twst = TWSR & 0xF8;
	if ( (twst != TW_MT_SLA_ACK) && (twst != TW_MR_SLA_ACK) ) return 1; // kiem tra ack 

	return 0;

}/* i2c_start */

void I2c_start_wait(unsigned char address)
{
    char twst;


    while ( 1 )
    {
        // send START condition
        TWCR = (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
    
        // wait until transmission completed
        while(!(TWCR & (1<<TWINT)));
    
        // check value of TWI Status Register. Mask prescaler bits.
        twst = TWSR & 0xF8;
        if ( (twst != TW_START) && (twst != TW_REP_START)) continue;
    
        // send device address
        TWDR = address;
        TWCR = (1<<TWINT) | (1<<TWEN);
    
        // wail until transmission completed
        while(!(TWCR & (1<<TWINT)));
    
        // check value of TWI Status Register. Mask prescaler bits.
        twst = TWSR & 0xF8;
        if ( (twst == TW_MT_SLA_NACK )||(twst ==TW_MT_DATA_NACK) ) 
        {            
            /* device busy, send stop condition to terminate write operation */
            TWCR = (1<<TWINT) | (1<<TWEN) | (1<<TWSTO);
            
            // wait until stop condition is executed and bus released
            while(TWCR & (1<<TWSTO));
            
            continue;
        }
        //if( twst != TW_MT_SLA_ACK) return 1;
        break;
     }

}/* i2c_start_wait */


unsigned char I2c_rep_start(unsigned char address)
{
    return I2c_start( address );

}/* i2c_rep_start */



void I2c_stop(void)
{
    /* send stop condition */
    TWCR = (1<<TWINT) | (1<<TWEN) | (1<<TWSTO);
    
    // wait until stop condition is executed and bus released
    while(TWCR & (1<<TWSTO));

}/* i2c_stop */


unsigned char I2c_write( unsigned char data )
{	
    char  twst;
    
	// send data to the previously addressed device
	TWDR = data;
	TWCR = (1<<TWINT) | (1<<TWEN);

	// wait until transmission completed
	while(!(TWCR & (1<<TWINT)));

	// check value of TWI Status Register. Mask prescaler bits
	twst = TWSR & 0xF8;
	if( twst != TW_MT_DATA_ACK) return 1;
	return 0;

}/* i2c_write */



void write_cmd1(char data){
     I2c_start(addr_oled);
      I2c_write(0x00); 
       I2c_write(data); 
       I2c_stop();
}

void cmd_list(unsigned char*c, int n){
      unsigned char  bytesOut = 1;
      I2c_start(addr_oled);
      I2c_write(0x00);  
       while(n--) {
        if(bytesOut >= WIRE_MAX) {
         I2c_stop();
         I2c_start(addr_oled);
         I2c_write(0x00);// Co = 0, D/C = 0
          bytesOut = 1;
        }
      I2c_write(*c++);
      bytesOut++;
    }
      I2c_stop();
}

void initDisplay()
{
    memset(buffer,0,1024); 
    write_cmd1(0xAE);          // 0xAE // display off  
    
    write_cmd1(0xD5);          // 0xD5 // set display clock division
    write_cmd1(0x80);          // the suggested ratio 0x80
    
    write_cmd1(0xA8);          // 0xA8 set multiplex
    write_cmd1(63);            // set height  
    
    
    write_cmd1(0xD3);          // set display offset
    write_cmd1(0x00);           // no offset 
    
    write_cmd1(0x40);            // line #0 setstartline
    write_cmd1(0x8D);          // 0x8D // chargepump 
    
    write_cmd1(0x14);    //?? 0x10
    
    write_cmd1(0x20);          // memory mode
    write_cmd1(0x00);          // 0x0 act like ks0108
    write_cmd1(0xA1);           // segremap  
    write_cmd1(0xC8);          // comscandec
    
    write_cmd1(0xDA);          // 0xDA set com pins
    write_cmd1(0x12); 
    
    write_cmd1(0x81);          // 0x81 // set contract
    write_cmd1(0xCF);      //??  0x9F
    
    write_cmd1(0xD9);          // 0xd9 set pre-charge
    write_cmd1(0xF1);         //0x22
    
    write_cmd1(0xDB);          // SSD1306_SETVCOMDETECT
    write_cmd1(0x40);
    write_cmd1(0xA4);          // 0xA4 // display all on resume
    write_cmd1(0xA6);          // 0xA6 // normal display
    write_cmd1(0x2E);          // deactivate scroll
    
    write_cmd1(0xAF);          // --turn on oled panel

}
  //// wire max =32 
void display()
{
   
    int  count = WIDTH * ((HEIGHT + 7) / 8);
    unsigned char *ptr   = buffer; 
    unsigned char bytesOut = 1;

    unsigned char dlist1[] = {
     SSD1306_PAGEADDR,
     0,                         // Page start address
     0xFF,                      // Page end (not really, but works here)
     SSD1306_COLUMNADDR,
     0 };                       // Column start address
    cmd_list(dlist1, sizeof(dlist1));
    write_cmd1(WIDTH - 1); 
    
    

   I2c_start(addr_oled);
   I2c_write((unsigned)0x40);
    while(count--) {
      if(bytesOut >= WIRE_MAX) {
       I2c_stop();
         I2c_start(addr_oled);
        I2c_write((unsigned)0x40);
        bytesOut = 1;
      }
      I2c_write(*ptr++);
      bytesOut++;
    }
     I2c_stop();
   

}

void drawpixel(int x, int y ){
    
  if((x >= 0) && (x <WIDTH) && (y >= 0) && (y < HEIGHT)) {
    buffer[x + (y/8)*WIDTH] |=  (1 << (y&7)); // 
   }
    

  
}
// gui lenh laf 0x00 
// gui data 0x40 
void clear(){
    memset(buffer,0,1024);
}

void draw1(int x, int y ){
int i,j; 
    for(i =x+3; i<x+6; i++){  
       for(j=y ;j<y+8 ;j++){
        drawpixel(i,j);
       }
    }
}
 
void draw2(int x, int y ){
int j; 
    
       for(j=y ;j<y+8 ;j++){
        
        drawpixel(j,x+1);
         drawpixel(j,x+6);
          drawpixel(j,x+7);
       }

      
         for(j=y+2 ;j<y+6 ;j++){
          drawpixel(j,x);
       }
     
        drawpixel(y+6,x+2);
        drawpixel(y+7,x+2);   
        drawpixel(y+4,x+3);
        drawpixel(y+5,x+3);
        drawpixel(y+4,x+4);
        drawpixel(y+3,x+4);
        drawpixel(y+3,x+5);
        drawpixel(y+2,x+5);
}

void draw3(int x, int y ){
int j; 
    for(j=y ;j<y+8 ;j++){
        
        drawpixel(j,x+1);
         drawpixel(j,x+6);
       } 
        for(j=y+2 ;j<y+6 ;j++){
          drawpixel(j,x);
           drawpixel(j,x+7);
       }   
        drawpixel(y+6,x+2);
        drawpixel(y+7,x+2);   
       
        drawpixel(y+6,x+5);
        drawpixel(y+7,x+5);
          
        drawpixel(y+4,x+3);
        drawpixel(y+5,x+3);
        drawpixel(y+4,x+4);
        drawpixel(y+5,x+4);
}

void draw4(int x, int y ){
int i,j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+5);
     }
      for(i =x+0; i<x+8; i++){
        drawpixel(y+6,i);
        drawpixel(y+5,i);
      }
      for(i =x+1; i<x+5; i++){
        drawpixel(y+(5-(i-x)),i);
       
      }
}

void draw6(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+1);
     }    
       for(j=y+2 ;j<y+6 ;j++){
         drawpixel(j,x);
            drawpixel(j,x+3); 
             drawpixel(j,x+7);
     }
     
      drawpixel(y+0,x+2);
        drawpixel(y+0,x+3);
         drawpixel(y+1,x+2);
        drawpixel(y+1,x+3);    
      drawpixel(y+0,x+4);
        drawpixel(y+0,x+5);
         drawpixel(y+1,x+4);
        drawpixel(y+1,x+5);   
        drawpixel(y+6,x+4);
        drawpixel(y+6,x+5);
         drawpixel(y+7,x+4);
        drawpixel(y+7,x+5);
       
                 
}


void draw5(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+1);
     }    
       for(j=y+2 ;j<y+6 ;j++){
         drawpixel(j,x);
            drawpixel(j,x+3); 
             drawpixel(j,x+7);
     }
     
      drawpixel(y+0,x+2);
        drawpixel(y+0,x+3);
         drawpixel(y+1,x+2);
        drawpixel(y+1,x+3);      
        drawpixel(y+6,x+4);
        drawpixel(y+6,x+5);
         drawpixel(y+7,x+4);
        drawpixel(y+7,x+5);
          drawpixel(y,x);
          drawpixel(y+1,x); 
}

void draw7(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x);
           }
      
      drawpixel(y+0,x+1);
       drawpixel(y+7,x+1);
       drawpixel(y+6,x+3);
         drawpixel(y+1,x+1);
        drawpixel(y+4,x+4);
        drawpixel(y+4,x+5);
         drawpixel(y+5,x+4);
        drawpixel(y+5,x+5);
          drawpixel(y+6,x+2);
        drawpixel(y+6,x+3);
         drawpixel(y+7,x+2);
        drawpixel(y+7,x+3);
         drawpixel(y+4,x+6);
        drawpixel(y+4,x+7);
         drawpixel(y+3,x+6);
        drawpixel(y+3,x+7); 
}

void draw8(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+1);
     }    
       for(j=y+2 ;j<y+6 ;j++){
            drawpixel(j,x);
            drawpixel(j,x+3);
              drawpixel(j,x+4);  
             drawpixel(j,x+7);
     }
     
      drawpixel(y+0,x+2);
       // drawpixel(y+0,x+3);
         drawpixel(y+1,x+2);
        drawpixel(y+1,x+3);    
       //drawpixel(y+0,x+4);
        drawpixel(y+0,x+5);
         drawpixel(y+1,x+4);
        drawpixel(y+1,x+5);   
        drawpixel(y+6,x+4);
        drawpixel(y+6,x+5);
       //  drawpixel(y+7,x+4);
        drawpixel(y+7,x+5);
       
        drawpixel(y+6,x+2);
        drawpixel(y+6,x+3);
         drawpixel(y+7,x+2);
       // drawpixel(y+7,x+3);       
}

void draw9(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+1);
     }    
       for(j=y+2 ;j<y+6 ;j++){
         drawpixel(j,x);
            drawpixel(j,x+3); 
             drawpixel(j,x+7);
     }
     
        drawpixel(y+0,x+2);
        drawpixel(y+0,x+3);
         drawpixel(y+1,x+2);
        drawpixel(y+1,x+3);       
        drawpixel(y+6,x+4);
        drawpixel(y+6,x+5);
        drawpixel(y+7,x+4);
        drawpixel(y+7,x+5);
        drawpixel(y+6,x+2);
        drawpixel(y+6,x+3);
        drawpixel(y+7,x+2);
        drawpixel(y+7,x+3);
                 
}

void draw0(int x, int y ){
int j; 
     for(j=y ;j<y+8 ;j++){
         drawpixel(j,x+6);
            drawpixel(j,x+1);
     }    
       for(j=y+2 ;j<y+6 ;j++){
         drawpixel(j,x);
          //  drawpixel(j,x+3); 
             drawpixel(j,x+7);
     }
     
        drawpixel(y+0,x+2);
        drawpixel(y+0,x+3);
         drawpixel(y+1,x+2);
        drawpixel(y+1,x+3);    
        drawpixel(y+0,x+4);
        drawpixel(y+0,x+5);
        drawpixel(y+1,x+4);
        drawpixel(y+1,x+5);   
        drawpixel(y+6,x+4);
        drawpixel(y+6,x+5);
        drawpixel(y+7,x+4);
        drawpixel(y+7,x+5);
        drawpixel(y+6,x+2);
        drawpixel(y+6,x+3);
        drawpixel(y+7,x+2);
        drawpixel(y+7,x+3);
                 
}

//void drawH(int x, int y ){
// int i, j; 
//         for(i =x; i<x+8; i++){
//            drawpixel(y,i);
//            drawpixel(y+1,i);
//            drawpixel(y+6,i);
//            drawpixel(y+7,i);
//         }
//       
//         for(j=y+2 ;j<y+6 ;j++){
//         drawpixel(j,x+3);
//          //  drawpixel(j,x+3); 
//             drawpixel(j,x+4);
//     }         
//}
//
//void drawU(int x, int y ){
// int i, j; 
//         for(i =x; i<x+6; i++){
//            drawpixel(y,i);
//            drawpixel(y+1,i);
//            drawpixel(y+6,i);
//           // drawpixel(y+7,i);
//         }  
//          for(i =x; i<x+8; i++){
//          
//            drawpixel(y+7,i);
//         }
//       
//         for(j=y+2 ;j<y+6 ;j++){
//           drawpixel(j,x+6);
// 
//           drawpixel(j,x+7);
//     }         
//}
//
//void drawV(int x, int y ){
// int i, j; 
//         for(i =x; i<x+6; i++){
//            drawpixel(y,i);
//            drawpixel(y+1,i);
//            drawpixel(y+6,i);
//            drawpixel(y+7,i);
//         }  
//        
//       
//         for(j=y+2 ;j<y+6 ;j++){
//           drawpixel(j,x+6);
// 
//           drawpixel(j,x+7);
//     }         
//}
//
//void drawP(int x, int y ){
// int i, j; 
//         for(i =x; i<x+8; i++){
//            drawpixel(y,i);
//            drawpixel(y+1,i);
//           
//         }  
//        
//       
//         for(j=y+2 ;j<y+5 ;j++){
//           drawpixel(j,x+0);
// 
//           drawpixel(j,x+3);
//         }
//         drawpixel(y+5,x+1);
//         drawpixel(y+5,x+2); 
//              
//}
//
//
//void drawR(int x, int y ){
// int i, j; 
//         for(i =x; i<x+8; i++){
//            drawpixel(y,i);
//            drawpixel(y+1,i);
//           
//         }  
//        
//       
//         for(j=y+2 ;j<y+5 ;j++){
//           drawpixel(j,x+0);
// 
//           drawpixel(j,x+3);
//         }
//         drawpixel(y+5,x+1);
//         drawpixel(y+5,x+2); 
//          drawpixel(y+5,x+6);
//         drawpixel(y+5,x+7);
//         
//          drawpixel(y+5,x+5);
//          drawpixel(y+6,x+7); 
//          
//          drawpixel(y+4,x+3);
//          drawpixel(y+5,x+4);     
//}
//
//
//void drawS(int x, int y ){
//
//        drawpixel(y+3,x+0);  
//         drawpixel(y+4,x+0);
//          drawpixel(y+5,x+0);
//
//        //drawpixel(y+1,x+1);
//        drawpixel(y+2,x+1);
//        drawpixel(y+3,x+1);
//        drawpixel(y+5,x+1);
//        drawpixel(y+6,x+1);
//        
//        //drawpixel(y+1,x+2);
//        drawpixel(y+2,x+2);
//        drawpixel(y+6,x+2);
//        
//        drawpixel(y+3,x+3);
//        drawpixel(y+4,x+4);
//       
//        drawpixel(y+1,x+5);
//        drawpixel(y+5,x+5);
//       // drawpixel(y+6,x+5);
//       //  drawpixel(y+1,x+1);
//         
//        drawpixel(y+2,x+6);
//        drawpixel(y+1,x+6);
//        drawpixel(y+4,x+6);
//        drawpixel(y+5,x+6);
//       // drawpixel(y+6,x+6);
//        
//        drawpixel(y+3,x+7);  
//         drawpixel(y+4,x+7);
//          drawpixel(y+2,x+7);          
//}
//void drawC(int x, int y ){
//        int j; 
//        for (j =y+3;j<y+6;j++){
//            drawpixel(j,x+0);  
//            drawpixel(j,x+7);
//
//        }   
//        
//        drawpixel(y+2,x+1);
//        drawpixel(y+6,x+1);
//        
//       
//        drawpixel(y+2,x+2);
//        drawpixel(y+1,x+2);
//        
//        drawpixel(y+1,x+3);
//        drawpixel(y+2,x+3);
//         drawpixel(y+1,x+4);
//        drawpixel(y+2,x+4);
//        
//      drawpixel(y+1,x+5);
//        drawpixel(y+2,x+5);
//         
//        drawpixel(y+2,x+6);
//        drawpixel(y+6,x+6);
//      
//               
//}
//
//
//
//void drawTwoPoint(int x, int y ){  
//        drawpixel(y+1,x+7);
//        drawpixel(y+2,x+7);
//         
//        drawpixel(y+1,x+6);
//        drawpixel(y+2,x+6);
//        drawpixel(y+1,x+0);
//        drawpixel(y+2,x+0);
//         
//        drawpixel(y+1,x+1);
//        drawpixel(y+2,x+1);
//               
//}



void drawBitmap(int x, int y, unsigned char bitmap[], int w, int  h) {
   int i, j; 
   int byteWidth= (w+7)/8; 
   int  byte = 0;
  for ( j = 0; j < h; j++) {
    for ( i = 0; i < w; i++) { 

          if (i & 7)
          byte <<= 1;
          else
          byte = bitmap[j * byteWidth + i / 8];
         if(byte & 0x80){
            drawpixel(x + i,y+j);
         }
 
    
    }
  }

}

void drawImage(unsigned char bitmap[],int  LOGO_HEIGHT,int  LOGO_WIDTH){
    drawBitmap(
    (WIDTH  - LOGO_WIDTH ) / 2,
    (HEIGHT - LOGO_HEIGHT) / 2,
    bitmap, LOGO_WIDTH, LOGO_HEIGHT);
}

void main(void)
{
  char temstr[5]; 
  funtion[0] =draw0;
  funtion[1] =draw1;
  funtion[2] =draw2;
  funtion[3] =draw3;
  funtion[4] =draw4;
  funtion[5] =draw5;
  funtion[6] =draw6;
  funtion[7] =draw7; 
  funtion[8] =draw8;
  funtion[9] =draw9;
  uart_Init();
   #asm("sei"); 
  I2c_init(); 
  initDisplay();  
  while (1)
      {
       clear();
      if(!flag){ 
      drawImage(logo_bmp,67,45);
      
      }else{
       memset(temstr,0,5);
       itoa(temp,temstr); 
       funtion[temstr[0]-48](30,20); 
       funtion[temstr[1]-48](30,30);
       // flag=0;
     }
         display(); 
      }
}
