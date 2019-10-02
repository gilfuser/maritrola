#include <Encoder.h>
#define qBlink() (digitalWriteFast(LED_BUILTIN, !digitalReadFast(LED_BUILTIN) ))  // Pin13 on T3.x & LC

float filterAfast = 0.7; //initialization of EMA alpha 0 to 1. The bigger the faster, the slower the smoother
float filterAlpha = 0.5; //initialization of EMA alpha 0 to 1. The bigger the faster, the slower the smoother
float filterAsmooth = 0.1; //initialization of EMA alpha 0 to 1. The bigger the faster, the slower the smoother

uint16_t oldXfader;
uint16_t filteredXfader;

long oldSelectB;
long oldSelectL;
/*
  byte lastBtnBstate = LOW;
  byte lastBtnLstate = LOW;
*/
byte oldAmpB;
byte filtAmpB;

byte oldAmpL;
byte filtAmpL;

uint16_t oldPitchB;
uint16_t filtPitchB;

uint16_t oldPitchL;
uint16_t filtPitchL;

Encoder selectbEnc(7, 8);
Encoder selectlEnc(5, 6);

byte oldInByte = 0;         // incoming serial byte
byte inByte = 222;

byte changes[12] = {254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255 };
byte oldChanges[12] = { 254, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 255 };

void setup()
{
  Serial.begin(38400);
  //  pinMode(10, INPUT_PULLUP);
  //  pinMode(11, INPUT_PULLUP);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  while (!Serial && (millis() <= 4000))
  {
    qBlink();
    delay(50);
  }
}

elapsedMillis emilBlink;  // Teensy way to delay action without delay()

// compare arrays
boolean checkArrays(byte arrayA[], byte arrayB[], byte numItems) {
  boolean same = true;
  byte i = 0;
  while (i < numItems && same) {
    same = arrayA[i] == arrayB[i];
    i++;
  }
  return same;
}

void loop()
{
  long selectB, selectL;
  /*  if (Serial.available() > 0)
    {
      if (inByte != oldInByte) {
        oldInByte = inByte;
  */
  if ( emilBlink > 1000 ) {
    qBlink();
    emilBlink = 0;
  }

  uint16_t xFader = analogRead(A0);
  selectB = byte(( selectbEnc.read() + 10000) % 255); // poorly working when turning counter clockwise. A mechanical issue? Problem in the circuit? non-interrupt pin?
  // byte btnBstate = digitalRead(9); // not working
  selectL = byte(( selectlEnc.read() + 10000) % 255); // same as the other
  // byte btnLstate = digitalRead(8);
  byte ampB = analogRead(A2) / 4;
  byte ampL = analogRead(A1) / 4;
  uint16_t pitchB = analogRead(A4);
  uint16_t pitchL = analogRead(A3);

  filteredXfader = (filterAfast * xFader) + ((1 - filterAfast) * filteredXfader); //run the EMA

  if ( filteredXfader != oldXfader ) {
    oldXfader = filteredXfader;
    changes[1] = filteredXfader >> 8;
    changes[2] = filteredXfader;
  }
  
  if ( selectB != oldSelectB ) {
    oldSelectB = selectB;
    changes[3] = selectB;
  }
  
  if ( selectL != oldSelectL ) {
    oldSelectL = selectL;
    changes[4] = selectL;
  }
  
  filtAmpB = (filterAlpha * ampB) + ((1 - filterAlpha) * filtAmpB); //run the EMA
  if ( filtAmpB != oldAmpB ) {
    oldAmpB = filtAmpB;
    changes[5] = filtAmpB;
  }
  
  filtAmpL = (filterAlpha * ampL) + ((1 - filterAlpha) * filtAmpL); //run the EMA
  if ( filtAmpL != oldAmpL ) {
    oldAmpL = filtAmpL;
    changes[6] = filtAmpL;
  }
  
  filtPitchB = (filterAsmooth * pitchB) + ((1 - filterAsmooth) * filtPitchB); //run the EMA
  if ( filtPitchB != oldPitchB ) {
    oldPitchB = filtPitchB;
    changes[7] = filtPitchB >> 8;
    changes[8] = filtPitchB;
  }
  
  filtPitchL = (filterAsmooth * pitchL) + ((1 - filterAsmooth) * filtPitchL); //run the EMA
  if ( filtPitchL != oldPitchL ) {
    oldPitchL = filtPitchL;
    changes[9] = filtPitchL >> 8;
    changes[10] = filtPitchL;
  }

  if ( checkArrays(changes, oldChanges, 12) == 0 )
  {
    Serial.write(changes, 12);
  }
  else
  {
    Serial.write(0);
  }

  for (byte i = 0; i < 12; i++)
  {
    if (changes[i] != oldChanges[i])
    {
      oldChanges[i] = changes[i];
    }
  }
  delay(4);
}

/*
   void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write(65);
    delay(300);
  }
  }
*/
