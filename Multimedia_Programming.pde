//Multimedia Assignment
//A program to implement a graphical menu bar system and drawing tools


int buttonSizeY = 20;                        //Sets up the button height
int itemButtonSizeX = 120;                   //Sets up the item button size
int totalMenuBarWidth = 0;                   //Sets up the total menu bar width holder
MenuBar menuBar1;                            //Declares the menu bar from class MenuBar

PImage img;                                  //Declares the image store for the menu dropdown
int[] currentMenuCoordinates = {0,0,0,0};    //Declares the coordinate array for the menu image store
String currentState = "";                    //Sets up the current state string 
String currentColour = "";                   //Sets up the current colour string
String currentStroke = "";                   //Sets up the current stroke
boolean drawStarted = false;                 //Sets up the drawStarted boolean for shape drawing
boolean drawStarted2 = false;                //Sets up the drawStarted2 boolean for triangle drawing
int startX = 0;                              //Sets up the drawing coordinate holders
int startX2 = 0;
int startY = 0;
int startY2 = 0;
int smallRubberSize = 10;                    //Sets the size of the small rubber
int bigRubberSize = 50;                      //Sets the size of the big rubber




//Initialises the application
void setup() {
  
  //sets the windows size to 640 x 480, framerate to 30fps and sets the background to white
  size(640, 480);
  frameRate(30);
  background(255);
  
  //Defines a menu bar and sets it up, using the MenuBar, Menu and MenuItem classes
  int menuBarLength = 5;
  int[] menuLengths = {4,4,5,2,2};
  String[] menuLabels = {"File", "Draw", "Colours", "Stroke", "Erase"};
  String[][] itemLabels = {{"New", "Open", "Save", "Exit", ""}, {"Line", "Rectangle", 
  "Triangle", "Ellipse", ""}, {"Black", "Red", "Green", "Blue", "Yellow"}, {"No Stroke", "Black Stroke"}, {"Big Rubber", "Small Rubber", "", "", ""}};
  menuBar1 = new MenuBar(menuBarLength, menuLengths, menuLabels, itemLabels);
  for(int i = 0; i < menuBar1.menus.length; i++) totalMenuBarWidth += menuBar1.menus[i].buttonWidth;
  
  //Draws the menubar
  menuBar1.DrawMenuBar();
}

void draw() { 
   //If the menu bar has been clicked it, it is drawn with the corresponding dropdown menu
   if (menuBar1.clicked == true) menuBar1.MenuBarClicked();
   
   //If the exit button has been clicked, exit the program
   if (currentState == "Exit") exit();
   else if (currentState == "New") {                                        //If the new button has been clicked, the canvas is reset
     background(255);
     currentState = "";
   } else if(currentState == "Save") {                                      //If the save button has been clicked, the current canvas is saved to 'currentimage.jpg'
     PImage saveimg = get(0, buttonSizeY + 4, width, height - buttonSizeY);
     saveimg.save("currentimage.jpg");
     currentState = "";
   } else if(currentState == "Open") {                                      //If the open button has been clicked, the image 'currentimage.jpg' is imported
     PImage openimg = loadImage("currentimage.jpg");
     image(openimg, 0, buttonSizeY, width, height - buttonSizeY);
     currentState = "";
   }
   menuBar1.MenuHover();                                                    //The appropriate hover shading is added to the menu
}


void mouseClicked() {
  if (mouseY > buttonSizeY || mouseX > totalMenuBarWidth) {                 //Checks if the mouse is over the menu bar
    
    //If the mouse isn't over the menu bar and the current state is shape drawing shape, handle multiple mouse clicks to draw shapes
    if (currentState == "Line" || currentState == "Rectangle" ||            
        currentState == "Triangle" || currentState == "Ellipse") {
       if (drawStarted == false) {                        //Saves the mouse information for the first click until the second
         startX = mouseX;
         startY = mouseY;
         drawStarted = true;
         drawStarted2 = false;
       } else {
          SetColour();                                    //Sets the colour using SetColour()
          SetStroke();                                    //Sets the stroke using SetStroke()
          if (currentState == "Rectangle") {
             drawStarted = false;
             rect(startX, startY, mouseX - startX, mouseY - startY);
          } else if (currentState == "Line") {
             drawStarted = false;
             line(startX, startY, mouseX, mouseY);
          } else if (currentState == "Triangle") {
             if (drawStarted2 == true) {
                triangle(startX, startY, startX2, startY2, mouseX, mouseY);
                drawStarted = false;
                drawStarted2 = false;
             } else {
               drawStarted2 = true;
               startX2 = mouseX;
               startY2 = mouseY;
             }
          } else if (currentState == "Ellipse") {
            drawStarted = false;
            ellipseMode(CORNERS);          //sets the ellipse definition to an ellipse described by a bound box
            ellipse(startX, startY, mouseX, mouseY);
          }
       }
    }
  } else {
    drawStarted = false;                   //if the mouse is over the menu bar then drawing cannot take place
    drawStarted2 = false;
  }
  
  //if a rubber is selected the 'rub out' (make white) the area clicked on
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
  
  
  //Works out which, if any, menu items has been clicked by incrementing y 'down' the current menu
  int x = 0;
  int y = buttonSizeY * 2;
  boolean itemClicked = false;
  for(int i = 0; i < menuBar1.currentMenu; i++) x += menuBar1.menus[i].buttonWidth;
  if (menuBar1.currentMenu != -1) {
    if (menuBar1.clicked == true && mouseX >= x && mouseX <= x + menuBar1.menus[menuBar1.currentMenu].buttonWidth
        && mouseY >= buttonSizeY && mouseY <= buttonSizeY * (menuBar1.menus[menuBar1.currentMenu].items.length + 1)) {
        int i = 0;
        do {
          if (mouseY <= y) {
              menuBar1.MenuItemClicked(menuBar1.currentMenu, i);
              itemClicked = true;
          }
          y += buttonSizeY;
          i++;
        } while (itemClicked == false && i < menuBar1.menus[menuBar1.currentMenu].items.length);
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

void SetStroke() {
  if (currentStroke == "Black Stroke") stroke(0);
  else noStroke();
}

class MenuBar {
  Menu[] menus;
  int menuWidth = 0;
  boolean selected = false;
  boolean hovered, clicked;       //Sets boolean triggers for the menu system
  int currentHover, currentMenu;  //Sets the integer placeholders for the current menu and hover
  
  MenuBar(int NumberOfMenus, int[] NumberOfItems, String[] MenuLabels, String[][] ItemLabels) {
    selected = false;
    menus = new Menu[NumberOfMenus];
    menuWidth = 0;
    hovered = false;
    clicked = false;
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
     drawStarted = false;
     drawStarted2 = false;
     currentHover = -1;
     currentMenu = -1;
     if(menuClicked == 2) {
       currentColour = menus[menuClicked].items[itemClicked].text;
     } else if (menuClicked == 3) {
       currentStroke = menus[menuClicked].items[itemClicked].text;
     } else currentState = menus[menuClicked].items[itemClicked].text;
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
