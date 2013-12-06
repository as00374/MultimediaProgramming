//Multimedia Assignment
//A program to implement a graphical menu bar system and drawing tools

//Sets up button sizes
int buttonSizeY = 20;
int itemButtonSizeX = 120;
MenuBar menuBar1;
boolean hovered, clicked, itemclicked;
PImage img, eraserimg;
int[] currentMenuCoordinates = {0,0,0,0};
int[] rectangleCoordinates = {0,0,0,0};
int currentHover;
int currentMenu;
String currentState = "";
String currentColour = "";
boolean drawStarted = false;
boolean drawStarted2 = false;
int startX = 0;
int startX2 = 0;
int startY = 0;
int startY2 = 0;
int smallRubberSize = 10;
int bigRubberSize = 50;



//Initialises the application
void setup() {
  
  //sets the windows size to 640 x 480, framerate to 30fps and sets the background to white
  size(640, 480);
  frameRate(30);
  background(255);
  hovered = false;
  clicked = false;
  
  //Defines a menu bar and sets it up, using the MenuBar, Menu and MenuItem classes
  int menuBarLength = 4;
  int[] menuLengths = {4,4,5,2};
  String[] menuLabels = {"File", "Draw", "Colours", "Erase"};
  String[][] itemLabels = {{"New", "Open", "Save", "Exit", ""}, {"Line", "Rectangle", 
  "Triangle", "Ellipse", ""}, {"Black", "Red", "Green", "Blue", "Yellow"}, {"Big Rubber", "Small Rubber", "", "", ""}};
  menuBar1 = new MenuBar(menuBarLength, menuLengths, menuLabels, itemLabels);
  
  //Draws the menubar
  menuBar1.DrawMenuBar();
}

void draw() { 
   if (clicked == true) menuBar1.MenuBarClicked();
   if (currentState == "Exit") exit();
   else if (currentState == "New") {
     background(255);
     currentState = "";
   } else if(currentState == "Save") {
     PImage saveimg = get(0, buttonSizeY, width, height - buttonSizeY);
     saveimg.save("currentimage.jpg");
     currentState = "";
   } else if(currentState == "Open") {
     PImage openimg = loadImage("currentimage.jpg");
     image(openimg, 0, buttonSizeY, width, height - buttonSizeY);
     currentState = "";
   }
`
   menuBar1.MenuHover();
}


void mouseClicked() {
  SetColour();
  if (currentState == "Line" || currentState == "Rectangle" || currentState == "Triangle" || 
      currentState == "Ellipse") {
     if (drawStarted == false) {
       startX = mouseX;
       startY = mouseY;
       drawStarted = true;
       drawStarted2 = false;
     } else {
        if (drawStarted2 == true) {
          triangle(startX, startY, startX2, startY2, mouseX, mouseY);
          drawStarted = false;
          drawStarted2 = false;
        } else if (currentState == "Rectangle") {
           drawStarted = false;
           rect(startX, startY, mouseX - startX, mouseY - startY);
        } else if (currentState == "Line") {
           drawStarted = false;
           line(startX, startY, mouseX, mouseY);
        } else if (currentState == "Triangle") {
           drawStarted2 = true;
           startX2 = mouseX;
           startY2 = mouseY;
        } else if (currentState == "Ellipse") {
          drawStarted = false;
          drawStarted2 = false;
          ellipseMode(CORNERS);
          ellipse(startX, startY, mouseX, mouseY);
        }
     }
  }
  
  if (currentState == "Big Rubber") {
    noStroke();
    fill(255);
    ellipseMode(RADIUS);
    ellipse(mouseX, mouseY, bigRubberSize, bigRubberSize);
  } else if(currentState == "Small Rubber") {
    noStroke();
    fill(255);
    ellipseMode(RADIUS);
    ellipse(mouseX, mouseY, smallRubberSize, smallRubberSize);
  }
  stroke(255);
  
  
  int x = 0;
  int y = buttonSizeY * 2;
  boolean itemClicked = false;
  for(int i = 0; i < currentMenu; i++) x += menuBar1.menus[i].buttonWidth;
  if (currentMenu != -1) {
    if (clicked == true && mouseX >= x && mouseX <= x + menuBar1.menus[currentMenu].buttonWidth
        && mouseY >= buttonSizeY && mouseY <= buttonSizeY * (menuBar1.menus[currentMenu].items.length + 1)) {
        int i = 0;
        do {
          if (mouseY <= y) {
              menuBar1.MenuItemClicked(currentMenu, i);
              itemClicked = true;
          }
          y += buttonSizeY;
          i++;
        } while (itemClicked == false && i < menuBar1.menus[currentMenu].items.length);
    }
  }

  menuBar1.MenuBarClickedEvent();
}

void SetColour() {
  if (currentColour == "Black") {
    fill(0);
    stroke(0);
  } else if (currentColour == "Red") {
    fill(255, 0, 0);
    stroke(255, 0, 0);
  } else if (currentColour == "Blue") {
    fill(0, 0, 255);
    stroke(0, 0, 255);
  } else if (currentColour == "Green") {
    fill(0, 255, 0);
    stroke(0, 255, 0);
  } else if (currentColour == "Yellow") {
    fill(255, 255, 0);
    stroke(255, 255, 0);
  }
}

class MenuBar {
  Menu[] menus;
  int menuWidth = 0;
  boolean selected = false;
  
  MenuBar(int NumberOfMenus, int[] NumberOfItems, String[] MenuLabels, String[][] ItemLabels) {
    selected = false;
    menus = new Menu[NumberOfMenus];
    menuWidth = 0;
    for(int i = 0; i < NumberOfMenus; i++) {
      menuWidth += int(textWidth(MenuLabels[i])) + 24;
      menus[i] = new Menu(NumberOfItems[i], MenuLabels[i], ItemLabels[i]);
    }
  }
  
  void MenuBarClicked() {
    int x = 0;
    int i = 0;
    clicked = false;
    do {
      if (mouseX <= x + menus[i].buttonWidth) {
          DrawMenuBarClicked(i);
          clicked = true;
      }
      x += menus[i].buttonWidth;
      i++;
    } while (clicked == false && i < menus.length);
    if (clicked == false) DrawMenuBar();
    clicked = true;
  }
  
  void MenuBarClickedEvent() {
    int x = 0;
    int i = 0;
    clicked = false;
    if (mouseY >= 0 && mouseY <= buttonSizeY) {
        do {
          if (mouseX <= x + menus[i].buttonWidth) {
              DrawMenuBarClicked(i);
              clicked = true;
          }
          x += menus[i].buttonWidth;
          i++;
        } while (clicked == false && i < menus.length);
     }
     if (clicked == false) {
       DrawMenuBar();
       if(currentMenuCoordinates[2] != 0) {
         image(img, currentMenuCoordinates[0], currentMenuCoordinates[1], 
            currentMenuCoordinates[2], currentMenuCoordinates[3]);
         for(i = 0; i < 4; i++) currentMenuCoordinates[i] = 0;
       }
       clicked = false;
       hovered = false;
    }
  }
  
  void MenuHover(){
  int i = 0;
  int x = 0;
  hovered = false;
   if (mouseY >= 0 && mouseY <= buttonSizeY) {
      do {
        if (mouseX <= x + menus[i].buttonWidth) {
            DrawMenuBarHovered(i);
            hovered = true;
        }
        x += menus[i].buttonWidth;
        i++;
      } while (hovered == false && i < menus.length);
    }
  if (hovered == false) DrawMenuBar(); 
  }
  
  void DrawMenuBar() {
    int buttonOffsetX = 0;
    currentHover = -1;
    //Sets up the button text font to Arial 16
    PFont font = loadFont("ArialMT-16.vlw");
    textFont(font, 16);
    
    for(int i = 0; i < menus.length; i++) {
        
        //Draws a grey button with black outline, with width appropriate for the button text
        fill(180);
        stroke(0);
        rect(buttonOffsetX, 0, menus[i].buttonWidth, buttonSizeY);
        
        //Draws the button's label with black font, in the centre of the button#
        fill(0);
        textSize(16);
        textAlign(CENTER, CENTER);
        text(menus[i].text, buttonOffsetX + (menus[i].buttonWidth / 2), buttonSizeY / 2);
        buttonOffsetX += menus[i].buttonWidth;
    }
  }
  
  void DrawMenuBarHovered(int buttonHovered) {
    int buttonOffsetX = 0;
    currentHover = buttonHovered;
    
    //Sets up the button text font to Arial 16
    PFont font = loadFont("ArialMT-16.vlw");
    textFont(font, 16);
    
    for(int i = 0; i < menus.length; i++) {
        
        //Draws a grey button with black outline, with width appropriate for the button text
        if (i == buttonHovered) {
          fill(100);
        } else {
          fill(180);
        }
        stroke(0);
        rect(buttonOffsetX, 0, menus[i].buttonWidth, buttonSizeY);
        
        //Draws the button's label with black font, in the centre of the button#
        fill(0);
        textSize(16);
        textAlign(CENTER, CENTER);
        text(menus[i].text, buttonOffsetX + (menus[i].buttonWidth / 2), buttonSizeY / 2);
        buttonOffsetX += menus[i].buttonWidth;
    }
  }
  
  void DrawMenuBarClicked(int buttonClicked) {
    DrawMenuBarHovered(buttonClicked);
    currentHover = buttonClicked;
    currentMenu = buttonClicked;
    if(currentMenuCoordinates[2] != 0) {
      image(img, currentMenuCoordinates[0], currentMenuCoordinates[1], 
            currentMenuCoordinates[2], currentMenuCoordinates[3]);
    }
    
    int x = 0;
    for(int i = 0; i < buttonClicked; i++) x += menus[i].buttonWidth;
    img = get(x, buttonSizeY, itemButtonSizeX + 2, (buttonSizeY * (menus[buttonClicked].items.length)) + 2);
    currentMenuCoordinates[0] = x;
    currentMenuCoordinates[1] = buttonSizeY;
    currentMenuCoordinates[2] = itemButtonSizeX + 2;
    currentMenuCoordinates[3] = (buttonSizeY * (menus[buttonClicked].items.length)) + 2;
    
    for(int i = 0; i < menus[buttonClicked].items.length; i++) {
      if(mouseY > buttonSizeY * (i + 1) && mouseY < buttonSizeY * (i + 2)) {
        fill(100);
      } else fill(180);
      stroke(0);
      rect(x, buttonSizeY * (i + 1), itemButtonSizeX, buttonSizeY);
      
      //Draws the button's label with black font, in the centre of the button#
        fill(0);
        textSize(16);
        textAlign(LEFT, CENTER);
        text(menus[buttonClicked].items[i].text, x + 12, buttonSizeY * ((i + 1) + 0.5));
    }
  }
  
  void MenuItemClicked(int menuClicked, int itemClicked) {
     DrawMenuBar();
     if(currentMenuCoordinates[2] != 0) {
       image(img, currentMenuCoordinates[0], currentMenuCoordinates[1], 
          currentMenuCoordinates[2], currentMenuCoordinates[3]);
       for(int i = 0; i < 4; i++) currentMenuCoordinates[i] = 0;
     }
     clicked = false;
     hovered = false;
     currentHover = -1;
     currentMenu = -1;
     if(menuClicked == 2) currentColour = menus[menuClicked].items[itemClicked].text;
     else currentState = menus[menuClicked].items[itemClicked].text;
  }
}

class Menu {
  String text;
  int buttonWidth;
  boolean selected = false;
  MenuItem[] items;
  
  Menu(int NumberOfItems, String MenuLabel, String[] ItemLabels) {
    text = MenuLabel;
    buttonWidth = int(textWidth(text)) + 24;
    items = new MenuItem[NumberOfItems];
    for(int i = 0; i < NumberOfItems; i++) {
      items[i] = new MenuItem(ItemLabels[i]);
    }
  }
}

class MenuItem {
  String text;
  boolean selected = false;
  
  MenuItem(String ItemLabel) {
    text = ItemLabel;
  }
}
