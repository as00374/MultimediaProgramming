//Multimedia Assignment
//A program to implement a graphical menu bar system and drawing tools

//Sets up button sizes
int buttonSizeY = 20;
MenuBar menuBar1;
boolean hovered;


//Initialises the application
void setup() {
  
  //sets the windows size to 640 x 480, framerate to 50fps and sets the background to white
  size(640, 480);
  frameRate(50);
  background(255);
  hovered = false;
  
  //Defines a menu bar and sets it up, using the MenuBar, Menu and MenuItem classes
  int menuBarLength = 4;
  int[] menuLengths = {4,4,2,1};
  String[] menuLabels = {"File", "Draw", "Erase", "Help"};
  String[][] itemLabels = {{"New", "Open", "Save", "Close"}, {"Line", "Rectangle", 
  "Triangle", "Ellipse"}, {"Rubber", "Click Erase", "", ""}, {"About", "", "", ""}};
  menuBar1 = new MenuBar(menuBarLength, menuLengths, menuLabels, itemLabels);
  
  //Draws the menubar
  DrawMenuBar(menuBar1);
}

void draw() {
   if (menuBar1.selected == false) MenuHover();
}

void MenuHover(){
  int i = 0;
  int x = 0;
  hovered = false;
   if (mouseY >= 0 && mouseY <= buttonSizeY) {
      do {
        if (mouseX <= x + menuBar1.menus[i].buttonWidth) {
            DrawMenuBarHovered(menuBar1, i);
            hovered = true;
        }
        x += menuBar1.menus[i].buttonWidth;
        i++;
      } while (hovered == false && i < menuBar1.menus.length);
   }
   if (hovered == false) DrawMenuBar(menuBar1); 
}

void DrawMenuBar(MenuBar newMenuBar) {
  int buttonOffsetX = 0;
  
  //Sets up the button text font to Arial 16
  PFont font = loadFont("ArialMT-16.vlw");
  textFont(font, 16);
  
  for(int i = 0; i < newMenuBar.menus.length; i++) {
      
      //Draws a grey button with black outline, with width appropriate for the button text
      fill(180);
      stroke(0);
      rect(buttonOffsetX, 0, newMenuBar.menus[i].buttonWidth, buttonSizeY);
      
      //Draws the button's label with black font, in the centre of the button#
      fill(0);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(newMenuBar.menus[i].text, buttonOffsetX + (newMenuBar.menus[i].buttonWidth / 2), buttonSizeY / 2);
      buttonOffsetX += newMenuBar.menus[i].buttonWidth;
  }
  
}

void DrawMenuBarHovered(MenuBar newMenuBar, int buttonHovered) {
  int buttonOffsetX = 0;
  
  //Sets up the button text font to Arial 16
  PFont font = loadFont("ArialMT-16.vlw");
  textFont(font, 16);
  
  for(int i = 0; i < newMenuBar.menus.length; i++) {
      
      //Draws a grey button with black outline, with width appropriate for the button text
      if (i == buttonHovered) {
        fill(100);
      } else {
        fill(180);
      }
      stroke(0);
      rect(buttonOffsetX, 0, newMenuBar.menus[i].buttonWidth, buttonSizeY);
      
      //Draws the button's label with black font, in the centre of the button#
      fill(0);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(newMenuBar.menus[i].text, buttonOffsetX + (newMenuBar.menus[i].buttonWidth / 2), buttonSizeY / 2);
      buttonOffsetX += newMenuBar.menus[i].buttonWidth;
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
  
  void MenuClicked() {
    
  }
  
}

class MenuItem {
  String text;
  boolean selected = false;
  
  MenuItem(String ItemLabel) {
    text = ItemLabel;
  }
  void ItemClicked() {
    
  }
}
