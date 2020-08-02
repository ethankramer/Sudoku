import java.util.*;
import java.lang.Math;


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
    line(0, 150*i, 450, 150*i);
  }

  for (int i=0; i<=3; i++) {
    strokeWeight(4);
    line(150*i, 0, 150*i, 450);
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
  globalSelect.selectCell();
}

public class Cell {
  private int x;
  private int y;
  private int number; //0 if empty, 1-9 otherwise
  private boolean isSelected;

  public Cell(int userX, int userY, int userNumber) {
    x = userX;
    y = userY;
    number = userNumber;
    isSelected = false;
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
      fill(0, 0, 0);
      text(""+this.number, this.x+15, this.y+38);
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
        Cell c = new Cell(j*50, i*50, 0);
        gameBoard[i][j] = c;
      }
    }

    gameBoard[0][3].changeNumber(5);
  }

  public Cell getCurrentCell(int row, int col) {
    return gameBoard[row][col];
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
