import java.util.*;
import java.lang.Math;

//Hello World

final int cellSize = 50;
Game g = new Game();
boolean menu = true;

Cell globalSelect = new Cell();

void setup() {
  size(600, 450);
  frameRate(60);
}

void draw() {
  if (menu) {
    //Creat Menu background
    fill(219);
    rect(0,0,600,450);
    //Create a Menu with 3 options
    
    //Easy Button
    fill(255, 187, 141);
    rect(250, 100, cellSize*2, cellSize);
    textSize(32);
    fill(0);
    text("Easy", 265, 136);
    
    //Medium Button
    fill(255, 187, 141);
    rect(250, 175, cellSize*2, cellSize);
    textSize(26);
    fill(0);
    text("Medium", 250, 210);
    
    //Hard Button
    fill(255, 187, 141);
    rect(250, 250, cellSize*2, cellSize);
    textSize(32);
    fill(0);
    text("Hard", 265, 286);
  } else {
    g.drawBoard();

    //Create a "Solve" Button
    fill(255, 187, 141);
    rect(475, 200, cellSize*2, cellSize);

    textSize(32);
    fill(0);
    text("Solve", 484, 236);

    //Create a "Reset" Button
    fill(255, 187, 141);
    rect(475, 125, cellSize*2, cellSize);

    textSize(32);
    fill(0);
    text("Reset", 484, 161);

    //Create a Back to Menu Button
    fill(255, 187, 141);
    rect(475, 275, cellSize*2, cellSize);
    
    textSize(32);
    fill(0);
    text("Menu", 484, 312);
    
    for (int i=0; i<=3; i++) {
      strokeWeight(4);
      line(0, 3*cellSize*i, 9*cellSize, 3*cellSize*i);
    }

    for (int i=0; i<=3; i++) {
      strokeWeight(4);
      line(3*cellSize*i, 0, 3*cellSize*i, 9*cellSize);
    }
    if (keyPressed) {
      String input = str(key);
      try {
        int x = Integer.parseInt(input);
        if ((x<1)||(x>9)) {
          System.out.println("Please enter a number 1 through 9");
        } else {
          //System.out.println(g.validMove(globalSelect.getY()/cellSize, globalSelect.getX()/cellSize, x)); 
          globalSelect.changeNumber(x);
        }
      } 
      catch (NumberFormatException e) {
        System.out.println("Please enter a number...");
      }
    }
  }
}

void mouseClicked() {
  if (menu) {
    //Currently on the menu screen
    //Check if user presses Easy, Medium, or Hard button
    
    if(250<=mouseX && mouseX<=350 && 100<=mouseY && mouseY<=150){
       menu = false;
       g.generateEasyBoard();
    }
    if(250<=mouseX && mouseX<=350 && 175<=mouseY && mouseY<=225){
       menu = false;
       g.generateMediumBoard();
    }
    if(250<=mouseX && mouseX<=350 && 250<=mouseY && mouseY<=300){
       menu = false;
       g.generateHardBoard();
    }
  } else {
    globalSelect.deSelectCell();

    //User selected cell
    int col = (mouseX/cellSize);
    int row = (mouseY/cellSize);

    //Make sure a cell was clicked
    if ((0<=col && col<9)&&(0<=row && row<9)) {
      globalSelect = g.getCurrentCell(row, col);
      if (!globalSelect.getGiven()) {
        globalSelect.selectCell();
      }
    }
    //Check if "Solve" Button was clicked
    if (475<=mouseX && mouseX<=575 && 200<=mouseY && mouseY <=250) {
      g.resetBoard();
      g.solve(0, 0);
    }

    //Check if "Reset" Button was clicked
    if (475<=mouseX && mouseX<=575 && 125<=mouseY && mouseY<=161) {
      g.resetBoard();
    }
    
    //Check if "Menu" button was clicked
    if(475<=mouseX && mouseX<=575 && 275<=mouseY && mouseY<=325){
       //g.resetBoard();
       menu=true;
    }
  }
}

public class Cell {
  private int x; //This Cell's column
  private int y; //This Cell's row
  private int number; //0 if empty, 1-9 otherwise
  private boolean isSelected; //Is this Cell currently selected for input?
  private boolean given; //Was this Cell given as a starting number? (Cannot be changed)
  private int[] possibilities;

  public Cell(int userX, int userY, int userNumber) {
    x = userX;
    y = userY;
    number = userNumber;
    isSelected = false;
    given = false;
    possibilities = new int[9];
  }

  //Default Constructor
  public Cell() {
    isSelected = false;
  }

  public void drawCell() {
    strokeWeight(1);
    if (this.isSelected) {
      fill(219, 219, 219);
      rect(this.x, this.y, cellSize, cellSize);
    } else {
      fill(255, 255, 255);
      rect(this.x, this.y, cellSize, cellSize);
    }

    if (this.number>0) {
      textSize(32);
      if (this.getGiven()) {
        fill(90, 90, 90);
        text(""+this.number, this.x+15, this.y+38);
      } else {
        fill(0, 0, 0);
        text(""+this.number, this.x+15, this.y+38);
      }
    }
  }

  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }

  public boolean getSelected() {
    return isSelected;
  }

  public boolean getGiven() {
    return given;
  }

  public int getNumber() {
    return this.number;
  }
  public void changeNumber(int num) {
    this.number = num;
  }

  public void selectCell() {
    isSelected=true;
  }
  public void deSelectCell() {
    isSelected=false;
  }

  public void initializeCell(int num) {
    this.number = num;
    given = true;
  }

  public void setGiven(boolean give) {
    this.given = give;
  }
}

public class Game {
  private Cell[][] gameBoard;
  private Random rng;
  private boolean isSolved = false;

  public Game() {
    gameBoard = new Cell[9][9];

    /********************************
     gameBoard[row][column] notation
     ********************************/

    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        Cell c = new Cell(j*cellSize, i*cellSize, 0);
        gameBoard[i][j] = c;
      }
    }

    rng = new Random();
    this.generateHardBoard();
  }

  public Cell getCurrentCell(int row, int col) {
    return gameBoard[row][col];
  }

  public void easyBoard() {
    gameBoard[0][0].initializeCell(2);
    gameBoard[1][0].initializeCell(3);
    gameBoard[4][0].initializeCell(1);
    gameBoard[5][0].initializeCell(8);
    gameBoard[6][0].initializeCell(7);
    gameBoard[7][0].initializeCell(9);

    gameBoard[1][1].initializeCell(4);
    gameBoard[2][1].initializeCell(8);
    gameBoard[4][1].initializeCell(9);
    gameBoard[5][1].initializeCell(7);

    gameBoard[2][2].initializeCell(1);
    gameBoard[7][2].initializeCell(8);
    gameBoard[8][2].initializeCell(6);

    gameBoard[0][3].initializeCell(8);
    gameBoard[3][3].initializeCell(9);
    gameBoard[7][3].initializeCell(5);

    gameBoard[1][4].initializeCell(2);
    gameBoard[2][4].initializeCell(5);
    gameBoard[6][4].initializeCell(9);
    gameBoard[7][4].initializeCell(6);

    gameBoard[1][5].initializeCell(9);
    gameBoard[5][5].initializeCell(3);
    gameBoard[8][5].initializeCell(4);

    gameBoard[0][6].initializeCell(1);
    gameBoard[1][6].initializeCell(8);
    gameBoard[6][6].initializeCell(6);

    gameBoard[3][7].initializeCell(7);
    gameBoard[4][7].initializeCell(8);
    gameBoard[6][7].initializeCell(5);
    gameBoard[7][7].initializeCell(1);

    gameBoard[1][8].initializeCell(5);
    gameBoard[2][8].initializeCell(3);
    gameBoard[3][8].initializeCell(2);
    gameBoard[4][8].initializeCell(6);
    gameBoard[7][8].initializeCell(4);
    gameBoard[8][8].initializeCell(9);
  }

  public void generateRandomBoard() {
    //Attempt to populate the initial board with 81 random numbers
    //Check to make sure the board has at least one solution each iteration
    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        int num = rng.nextInt(9)+1;
        if (this.validMove(i, j, num)) {
          gameBoard[i][j].initializeCell(num);
          if (!this.solve(0, 0)) {
            gameBoard[i][j].changeNumber(0);
            gameBoard[i][j].setGiven(false);
            j--;
          }
          this.resetBoard();
        }
      }
    }


    this.solve(0, 0);

    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        gameBoard[i][j].setGiven(true);
      }
    }
  }

  public void generateEasyBoard() {
    //Start board with 35 given cells

    this.generateRandomBoard();

    for (int i=0; i<46; i++) {
      int row=rng.nextInt(9);
      int col=rng.nextInt(9);
      if (gameBoard[row][col].getNumber()!=0) {
        gameBoard[row][col].changeNumber(0);
        gameBoard[row][col].setGiven(false);
      } else {
        i--;
      }
    }
  }

  public void generateMediumBoard() {
    //Start board with 27 given cells

    this.generateRandomBoard();

    for (int i=0; i<54; i++) {
      int row=rng.nextInt(9);
      int col=rng.nextInt(9);
      if (gameBoard[row][col].getNumber()!=0) {
        gameBoard[row][col].changeNumber(0);
        gameBoard[row][col].setGiven(false);
      } else {
        i--;
      }
    }
  }

  public void generateHardBoard() {
    //Start board with 20 given cells

    this.generateRandomBoard();

    for (int i=0; i<61; i++) {
      int row=rng.nextInt(9);
      int col=rng.nextInt(9);
      if (gameBoard[row][col].getNumber()!=0) {
        gameBoard[row][col].changeNumber(0);
        gameBoard[row][col].setGiven(false);
      } else {
        i--;
      }
    }
  }

  public void drawBoard() {
    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        Cell c = gameBoard[i][j];
        c.drawCell();
      }
    }
  }

  public void textBoard() {
    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        Cell c = gameBoard[i][j];
        if (j%3==0) {
          System.out.print(" |");
        }
        System.out.print(" "+c.getNumber());
      }
      if ((i+1)%3==0) {
        System.out.println();
        System.out.print(" -----------------------");
      }
      System.out.println();
    }
  }

  public boolean validMove(int row, int col, int num) {
    //Check rows (column stays constant)
    for (int rowNum=0; rowNum<9; rowNum++) {
      if (gameBoard[rowNum][col].getNumber()==num) {
        //System.out.println("Match found at: ("+(rowNum+1)+", "+(col+1)+")");
        return false;
      }
    }

    //Check columns (row stays constant)
    for (int colNum=0; colNum<9; colNum++) {
      if (gameBoard[row][colNum].getNumber()==num) {
        //System.out.println("Match found at: ("+(row+1)+", "+(colNum+1)+")");
        return false;
      }
    }

    //Check 3x3 Square for current cell
    int currRow = gameBoard[row][col].getY()/(3*cellSize);
    int currCol = gameBoard[row][col].getX()/(3*cellSize);
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        if (gameBoard[i+(currRow*3)][j+(currCol*3)].getNumber()==num) {
          //System.out.println("Match found at: ("+(i+(currRow*3)+1)+", "+(j+(currCol*3)+1)+")");
          return false;
        }
      }
    }
    return true;
  }

  public void resetBoard() {
    this.isSolved = false;
    for (int i=0; i<9; i++) {
      for (int j=0; j<9; j++) {
        if (!gameBoard[i][j].getGiven()) {
          gameBoard[i][j].changeNumber(0);
        }
      }
    }
  }
  public boolean solve(int row, int col) {
    //Recursive Function: parameters row and col represent where in the board to start each iteration

    //System.out.println("Trying to solve");
    if (row>=9) {
      this.isSolved=true;
      //System.out.println("Solved!");
      return this.isSolved;
    }

    if (!this.isSolved) {
      //System.out.println("Not Solved Yet");
      if (!gameBoard[row][col].getGiven()) {//First check to make sure we are not looking at a given cell
        for (int i=1; i<=9; i++) {
          if (this.validMove(row, col, i)) {
            gameBoard[row][col].changeNumber(i);

            if (col==8) {
              this.solve(row+1, 0);
            } else {
              this.solve(row, col+1);
            }
          }
        }
        if (!this.isSolved) {
          gameBoard[row][col].changeNumber(0);
        }
      } else {
        if (col==8) {
          this.solve(row+1, 0);
        } else {
          this.solve(row, col+1);
        }
      }
    }
    return this.isSolved;
  }
}
