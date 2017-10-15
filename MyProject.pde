//Liam Moynihan, 10/14/17, HackGT
PFont f;
PImage temp;
int worldWidth = 10000;
dimension[] dims;
image[] images;
scrollBar scl;
float scrollPoint;
boolean onScroll;
question q;
String[] questionAsk;
float[] questionSize;
int inc;

String[] qAsk = {"How much plastic is in the Great Pacific Garbage Patch?",
                 "How far does the average American drive per day?",
                 "How much ice was lost from the Artic in the past year?", 
                 "How much land has been deforrested in the last year?",
                 "How much land would we need to fill with solar pannels to power the entire USA?",
                 "How much freshwater is on our planet's surface?",
                 "How much land is still affected by the Fukushima nuclear disaster?",
                 "How much trash does the average American produce every year?"};
String[] qTit = {"The Pacific Garbage Patch",
                 "Drive Everywhere Culture",
                 "The Melting Artic Ice Caps",
                 "The Loss of Woodland Habitat",
                 "USA Green Energy Takeover",
                 "The Limits on Drinking Water",
                 "The Nuclear Disaster of Fukushima",
                 "Throwaway Culture in America"};
String[] qDes = {"At an estimated 510,000 square meteres, the Pacific Trash Vortex is a massive island of non-degradable trash drifting in the Pacific Ocean for as far back as 1988.",
                 "Americans drive about 37 miles every day. Concentration of population in the suburbs and a dependence on cars for transportation means that Americans spend nearly an hour a day in a car.",
                 "647,000,000 square meters of the polar ice caps disapear ever year, the artic ice caps are receding at record levels, with federal estimates of sea level rise being as high as 8ft by the end of the century.",
                 "77,000,000 square meters of forests are cut down every year, deforestation levels have declined in the past 25 years, but as populations rise, forests continue to shrink putting natural wildlife at high risk of extinction.",
                 "It would require 27,900,000,000 square meters of solar pannels to power the entire USA. This is 0.28% of the entire landmass. However, this number can be dramatically reduced through rooftop solar pannels.",
                 "There is about 70,000,000,000 square meters of fresh water on Earth, only about 2.5% of all water. Nearly two thirds of this is trapped in glaciers too! Freshwater is a limited resource too often wasted.",
                 "9 billion square meters around Japan have been affected by the nuclear disaster at Fukushima in 2011. Becuase of unsafe practices and inadquete response efforts, billions of square meters and millions of people were exposed to harmful radiation.",
                 "Americans produce on average 730 square meters of trash per year. That's about 2 square meters per day laid out flat, taller than most people! Wasteful practices are unsustainable and inefficient."};
float[] qSize = {510000, 95800000, 647000000, 77000000, 27900000000L, 70000000000L, 9000000000L, 730};

PImage img1, img2, img3, img4, img5, img6, img7, img8, img9, img10;

void setup() {
  size(1000, 400);
  f = createFont("Arial",16,true);

  textFont(f,32);
  inc = 0;

  scl = new scrollBar(20);
  
  images = new image[10];
  dims = new dimension[25];
  
  for (int i = 0; i < 25; i++) {
    dims[i] = new dimension(i*.5);
  }
  
  img1 = loadImage("person.jpg");
  images[0] = new image(img1,"A normal human being",1);
  img2 = loadImage("house.jpg");
  images[1] = new image(img2,"A standard american household",222);
  img3 = loadImage("mountain.jpg");
  images[2] = new image(img3,"An average mountain",1000000);
  img4 = loadImage("rhodeisland.jpg");
  images[3] = new image(img4,"The state of Rhode Island",3140000000L);
  img5 = loadImage("California.jpg");
  images[4] = new image(img5,"The state of California",424000000000L);
  img6 = loadImage("statue.jpg");
  images[5] = new image(img6,"The Statue of Liberty",2000);
  img7 = loadImage("hawaii.jpg");
  images[6] = new image(img7,"The Islands of Hawii",10000000000L);
  img8 = loadImage("paris.jpg");
  images[7] = new image(img8,"The City of Paris",105000000);
  img9 = loadImage("tree.jpg");
  images[8] = new image(img9,"A Tree!",15);
  img10 = loadImage("pyramid.jpg");
  images[9] = new image(img10,"The Great Pyramid of Giza",52000);
  
  q = new question(qAsk[inc], qTit[inc], qDes[inc], qSize[inc++]);
}

void draw() {
  background(255);
  
  scl.update();
  scrollPoint = scl.getPos();
  onScroll = scl.over || scl.locked;
  
  for (int i = 0; i <= 9; i++) {
    images[i].display(onScroll);
    images[i].update(scrollPoint);
  }
  
  for (int i = 0; i < 25; i++) {
    dims[i].display();
    dims[i].update(scrollPoint);
  }
  
  q.display(onScroll);
  q.update(scrollPoint, onScroll);
  
  if (q.over && inc < 8) {
    q = new question(qAsk[inc], qTit[inc], qDes[inc], qSize[inc++]);
  }
  
  scl.display();
  
  if (inc >= 8 && q.over) {
    background(255);
    printEnd();
    noLoop();
  } 
}

void printEnd() {
  textFont(f,32);
  fill(0);
  textAlign(CENTER);
  text("Thank you for playing", width/2, 100);
  text("Change starts by recognizing the issue",width/2,200);
  textFont(f,28);
  text("Liam Moynihan, Nina Rodgers",width/2, 380);
}

class question {
  String ask;
  answer ans;
  selection sel;
  boolean over = false;
  question(String ask1, String tit, String cont,float siz) {
    ask = ask1;
    ans = new answer(siz, tit, cont);
    sel = new selection();
  }
  
  void display(boolean scrollLocked) {
    sel.display();
    ans.display(scrollLocked);
    fill(0,0,0);
    textFont(f,24);
    text(ask, 100, 20);
  }
  
  void update(float scrollPoint, boolean onScroll) {
    if (sel.done) {
      ans.show = true;
    }
    if (ans.done) {
      over = true;
    }
    ans.update(scrollPoint);
    sel.update(scrollPoint, onScroll);
  }
}

class answer {
  float startx, starty, x, y, valx;
  float relRadius;
  float unitSize = 100;
  boolean show = false;
  boolean done = false;
  textBox descript;
  int counter = 0;
  answer(float valx1, String tit, String cont) {
    valx = valx1;
    descript = new textBox(tit, cont);
    setVals();
  }
  
  void display(boolean scrollLocked) {
    if (show) {
      fill(200,0,0);
      noStroke();
      ellipse(x,y,relRadius,relRadius);
      if (mouseOver(scrollLocked)) {
        descript.display();
      }
    }
  }
  
  void setVals() {
    float scale = log(valx)/log(10);
    startx = scale * (worldWidth/12);
    starty = height/2;
    relRadius = 100;
  }
  
  void update(float dx) { //Scrollpoint
    x = startx - dx;
    y = starty;
    relRadius = 100*pow(10,constrain(((x-500)/833.3),-1.2,1.2));
    if (show) {
      if (counter++ > 50) {
        if (keyPressed) {
          done = true;
        }
      }
    }
  }
  
  boolean mouseOver(boolean scrollLocked) {
    return !scrollLocked && sqrt((mouseX-x)*(mouseX-x) + (mouseY-y)*(mouseY-y)) < relRadius/2;
  }
}

class selection {
  float x, y, valx, startx, starty;
  float relRadius =  0;
//  float unitSize = 100;
  boolean ready = false; 
  boolean done = false;
  
  selection() {
    startx = -100;
  };
  
  void display() {
    noStroke();
    if (done) {
      fill(0,200,0);
    } else {
      fill (100,255,100);
    }
    ellipse(x,y,relRadius,relRadius);
  }
  
  void update(float valx1, boolean onScroll) {
    if (!done && mousePressed && !onScroll) {
      startx = mouseX + valx1;
      starty = height/2;
      relRadius = 100;
      ready = true;
    }
    if (keyPressed && ready) {
      done = true;
    }
    x = startx - valx1;
    y = starty;
    relRadius = 100*pow(10,constrain(((x-500)/833.3),-1.2,1.2));
  }
  
  float getSize(float valx1) {
    float scale = (valx1 + x)*(12/10000);
    return pow(10,scale);
  }
}

class dimension {
  float startx, starty, x, y;
  float value; //0 -> 12
  
  dimension(float val) {
    value = val;
    starty = height - 50;
    startx = val * worldWidth/12;
  }
  
  void display() {
    if (x > 400 && x < 600) {
      fill(150,150,0);
    } else {
      fill(0, 0, 0);
    }
    stroke(0, 0, 0);
    line(x, height-20, x, height-35);
    textFont(f,16);
    text("10^"+value+"m^2", x-25, height-38);
  }
  
  void update(float dx) {
    x = startx - dx;
    y = starty;
  }
}

class image {
  PImage img, temp;
  float scl;
  float startx, starty, x, y;
  int newwidth;
  String title;
  
  image(PImage img1, String tit, float scl1) {
    img = img1;
    title = tit;
    scl = scl1;
    
    float scale = log(scl)/log(10);
    startx = scale * (worldWidth/12);
    starty = height/2 - 150;
  }
  
  void display(boolean scrollLocked) {
    if (x > -100 && x < width) {
      temp = img.copy();
      newwidth = int(300*pow(10,constrain((x-500)/833.3, -1.2, 1.2)));
      temp.resize(newwidth, 0);
      image(temp,x,height/2 - newwidth/2); 
      if (mouseOver(scrollLocked)) {
        fill(255,255,255);
        rect(395, height - 122, textWidth(title) + 10, 29);
        fill(0,0,0);
        text(title, 400, height - 100);
      } 
    }
  }
  
  boolean mouseOver(boolean scrollLocked) {
    return !scrollLocked && mouseX > x && mouseX < newwidth + x && mouseY > (height/2 - newwidth/2) && mouseY < (height/2 + newwidth/2);
  }
  
  void update(float dx) {
    x = startx - dx;
    y = starty;
  }
}

class textBox {
  String title;
  String contents;
  textBox(String t, String c) {
    title = t;
    contents = c;
  }
  
  void display() {
    stroke(0);
    fill(255,255,255);
    strokeWeight(3);
    rect(10, 40, textWidth(title) + 10, 300);
    fill(0,0,0);
    line(10, 70, textWidth(title) + 20, 70);
    text(title, 15, 62);
    
    int x = 15;
    int y = 95;
    String word = "";
    for (int i = 0; i < contents.length() + 1; i++) {
      word += (i == contents.length()) ? " " : contents.charAt(i);
      if (word.charAt(word.length()-1) == ' ') {
        if (x + textWidth(word) > textWidth(title) + 3) {
          y += 25;
          x = 15;
          text(word, x, y);
          x += textWidth(word);
          word = "";
        } else {
          text(word, x, y);
          x += textWidth(word);
          word = "";
        }
      }
    }
  }
}

class scrollBar {
 int swidth, sheight;
 float xp, yp;
 float sp, nsp;
 float spMin, spMax;
 int loose;
 boolean over;
 boolean locked;
 float ratio;
 
 scrollBar (int l) {
   swidth = width;
   sheight = 20;
   
   ratio = (float)(worldWidth-width) / (float)(width - 20);
   
   xp = 0;
   yp = height - sheight;
   
   sp = 0;//xp + swidth/2;
   nsp = sp;
   
   spMin = xp;
   spMax = xp + swidth - sheight;
   
   loose = l;
 }
 
 void update() {
   if (overEvent()) {
     over = true;
   } else {
     over = false;
   }
   
   if (mousePressed && over) {
     locked = true;
   }
   
   if (!mousePressed) {
     locked = false; 
   }
   
   if (locked) {
     nsp = constrain(mouseX, spMin, spMax);
   }
   
   if (abs(nsp - sp) > 1) {
     sp = sp + (nsp-sp)/loose;
   }
 }
 
 
 float constrain1(float val, float minv, float maxv) {
   return min(max(val, minv), maxv);
 }
 
 
 boolean overEvent() {
    if (mouseX > xp && mouseX < xp + swidth
        && mouseY > yp && mouseY < yp + sheight) {
          return true;
        } else {
          return false;
        }
 }
 
 void display() {
   noStroke();
   fill(200);
   rect(xp, yp, swidth, sheight);
   if (over || locked) {
     fill(40, 40, 40);
   } else {
     fill(100, 100, 150);
   }
   rect(sp, yp, sheight, sheight);
 }
 
 float getPos() {
   //Converst spos to a value between 0 & total scroll width
   return sp * ratio;
 }
}