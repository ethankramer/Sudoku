import java.util.*;
import java.lang.Math;

//Hello World

final int cellSize = 50;
Game g = new Game();

Cell globalSelect = new Cell();

void setup() {
  size(450, 450);
  frameRate(30);

  g.textBoard();
}

void draw() {
  g.drawBoard();

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
        globalSelect.changeNumber(x);
      }
    } 
    catch (NumberFormatException e) {
      System.out.println("Please enter a number...");
    }
  }
}

void mouseClicked() {
  globalSelect.deSelectCell();

  //User selected cell
  int col = (mouseX/cellSize);
  int row = (mouseY/cellSize);

  globalSelect = g.getCurrentCell(row, col);
  if (!globalSelect.getGiven()) {
    globalSelect.selectCell();
  }
}

public class Cell {
  private int x;
  private int y;
  private int number; //0 if empty, 1-9 otherwise
  private boolean isSelected;
  private boolean given;

  public Cell(int userX, int userY, int userNumber) {
    x = userX;
    y = userY;
    number = userNumber;
    isSelected = false;
    given = false;
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
}

public class Game {
  private Cell[][] gameBoard;

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

    //gameBoard[0][3].changeNumber(5);
    this.easyBoard();
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
}
