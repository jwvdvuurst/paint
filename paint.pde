
ArrayList<Integer> field = new ArrayList<Integer>();

int dimension = 40;
int number_stones = 64;
int max_stone=2;
int skips=0;

void setup() {
  size(900, 900);
  background(0);

  for ( int i=0; i<dimension*dimension; i++ ) {
    field.add(0);
  }

  int n=number_stones;

  while ( n>0 ) {
    int x = round(random(dimension));
    int y = round(random(dimension));

    if (x == dimension) x--;
    if (y == dimension) y--;

    int c = (y*dimension)+x;

    if (field.get(c) == 0) {
      field.set(c, 1);
      n--;
    }
  }
}

color convoludeLeft( color colors[] ) {
  float r;
  float g;
  float b;

  r = (red(colors[0])*2 + //<>//
    red(colors[1])*1 +
    red(colors[3])*4 +
    red(colors[4])*4 +
    red(colors[6])*2 +
    red(colors[7])*1) / 14;

  g = (green(colors[0])*2 +
    green(colors[1])*1 +
    green(colors[3])*4 +
    green(colors[4])*4 +
    green(colors[6])*2 +
    green(colors[7])*1) / 14;

  b = (blue(colors[0])*2 +
    blue(colors[1])*1 +
    blue(colors[3])*4 +
    blue(colors[4])*4 +
    blue(colors[6])*2 +
    blue(colors[7])*1) / 14;

  return color(r, g, b);
}

color convoludeRight( color colors[] ) {
  float r;
  float g;
  float b;

  r = (red(colors[2])*2 +
    red(colors[1])*1 +
    red(colors[5])*4 +
    red(colors[4])*4 +
    red(colors[8])*2 +
    red(colors[7])*1) / 14;

  g = (green(colors[2])*2 +
    green(colors[1])*1 +
    green(colors[5])*4 +
    green(colors[4])*4 +
    green(colors[8])*2 +
    green(colors[7])*1) / 14;

  b = (blue(colors[2])*2 +
    blue(colors[1])*1 +
    blue(colors[5])*4 +
    blue(colors[4])*4 +
    blue(colors[8])*2 +
    blue(colors[7])*1) / 14;

  return color(r, g, b);
}

color convoludeTop( color colors[] ) {
  float r;
  float g;
  float b;

  r = (red(colors[0])*2 +
    red(colors[3])*1 +
    red(colors[1])*4 +
    red(colors[4])*4 +
    red(colors[2])*2 +
    red(colors[5])*1) / 14;

  g = (green(colors[0])*2 +
    green(colors[3])*1 +
    green(colors[1])*4 +
    green(colors[4])*4 +
    green(colors[2])*2 +
    green(colors[5])*1) / 14;

  b = (blue(colors[0])*2 +
    blue(colors[3])*1 +
    blue(colors[1])*4 +
    blue(colors[4])*4 +
    blue(colors[2])*2 +
    blue(colors[5])*1) / 14;

  return color(r, g, b);
}

color convoludeBottom( color colors[] ) {
  float r;
  float g;
  float b;

  r = (red(colors[6])*2 +
    red(colors[3])*1 +
    red(colors[7])*4 +
    red(colors[4])*4 +
    red(colors[8])*2 +
    red(colors[5])*1) / 14;

  g = (green(colors[6])*2 +
    green(colors[3])*1 +
    green(colors[7])*4 +
    green(colors[4])*4 +
    green(colors[8])*2 +
    green(colors[5])*1) / 14;

  b = (blue(colors[6])*2 +
    blue(colors[3])*1 +
    blue(colors[7])*4 +
    blue(colors[4])*4 +
    blue(colors[8])*2 +
    blue(colors[5])*1) / 14;

  return color(r, g, b);
}

void draw() {
  background(0);
  stroke(255);
  float dx = ((width-100)/dimension);
  float dy = ((height-100)/dimension);

  //for ( int w = 50; w <= width-50; w+=round(dx) ) line(w, 50, w, height-50);
  //for ( int h = 50; h <= width-50; h+=round(dy) ) line(50, h, width-50, h);

  for ( int x = 0; x < dimension; x++ ) {
    for ( int y = 0; y < dimension; y++ ) {            
      color colors[] = new color[9];

      int n = 0;
      for ( int cy = -1; cy < 2; cy++ ) {
        for ( int cx = -1; cx < 2; cx++ ) {
          int px=x+cx;
          int py=y+cy;
          if ((px>=0) && (px<dimension) && 
            (py>=0) && (py<dimension)) {                
            int c = (py*dimension)+px;
            int fn = field.get(c);
            if (fn == 1) {
              colors[n] = color(128, 128, 0);
            } else if (fn > 1) {     
              int st=fn;
              int b=st%128;
              st=(st-b)/128;
              int g=st%128;
              st=(st-g)/128;
              int r=st%128;

              colors[n] = color(255-r, 255-g, 255-b);
            } else {
              colors[n] = color(0, 0, 0);
            }
          } else {
            colors[n] = color(0, 0, 0);
          }
          n++;
        }
      }

      color left = convoludeLeft(colors);
      color top = convoludeTop(colors);      
      color right = convoludeRight(colors);      
      color bottom = convoludeBottom(colors);      

      int sx = 50+round((x+0.5)*dx);
      int sy = 50+round((y+0.5)*dy);
      int l  = 0;
            
      for( int lx = round(50+(x*dx)); lx < sx; lx++ ) {
        stroke( lerpColor(left, colors[4], (2*l/dy) ) );
        line( lx, 50+(y*dy)+l, lx, 50+((y+1)*dy)-l );
        l += 1;
      }
        
      l = 0;  
      for( int lx = round(50+((x+1)*dx)); lx > sx; lx-- ) {
        stroke( lerpColor(right, colors[4], (2*l/dy) ) );
        line( lx, 50+(y*dy)+l, lx, 50+((y+1)*dy)-l );
        l += 1;
      }
      
      l=0;
      for( int ly = round(50+(y*dy)); ly < sy; ly++ ) {
        stroke(lerpColor(top, colors[4], (2*l/dx) ) );
        line( 50+(x*dx)+l, ly, 50+((x+1)*dy)-l, ly );
        l += 1;
      }

      l=0;
      for( int ly = round(50+((y+1)*dy)); ly > sy; ly-- ) {
        stroke(lerpColor(bottom, colors[4], (2*l/dx) ) );
        line( 50+(x*dx)+l, ly, 50+((x+1)*dy)-l, ly );
        l += 1;
      }

      int radius = round(0.9*dx);

      //circle(sx, sy, radius);
      
      //fill(colors[4]);
      //circle(sx, sy, round(radius/4));
    }
  }

  ArrayList<Integer> possibilities = new ArrayList<Integer>();

  for ( int x=0; x<dimension; x++ ) {
    for ( int y=0; y<dimension; y++ ) {      
      int c = (y*dimension)+x;

      if (field.get(c) == 0) {      
        int total=0;

        for ( int cx=-1; cx<2; cx++ ) {
          for ( int cy=-1; cy<2; cy++ ) {
            int fx=x+cx;
            int fy=y+cy;

            if ((fx >= 0) && (fx < dimension) && (fy >= 0) && (fy < dimension)) total += field.get((fy*dimension)+fx);
          }
        }

        if (total == max_stone) {
          possibilities.add(c);
        }
      }
    }
  }

  int x=2;
  while ((possibilities.size() > 0) && (x > 0)) {    
    int l = round(random(possibilities.size()));
    if (l == possibilities.size()) l--;
    field.set(possibilities.get(l), max_stone);
    possibilities.remove(l);
    skips=0;
    x--;
  } 
  
  if (x==2) {
    skips++;

    println( "Skipped ", max_stone, " --> nr. skips: ", skips );
  }
  max_stone++;

  if (skips*2>max_stone) noLoop();
}
