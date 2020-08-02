import java.util.*;
import java.lang.Math;

final int cellSize = 50;
Game g = new Game();

void setup(){
  size(450,450);
  frameRate(1);
  
  g.textBoard();
}

void draw(){
  g.drawBoard();
  
  for(int i=0; i<=3; i++){
    strokeWeight(4);
    line(0,150*i,450,150*i);
  }
  
  for(int i=0; i<=3; i++){
    strokeWeight(4);
    line(150*i,0,150*i,450);
  }
}

public class Cell{
  private int x;
  private int y;
  private int number; //0 if empty, 1-9 otherwise
  
  public Cell(int userX, int userY, int userNumber){
    x = userX;
    y = userY;
    number = userNumber;
  }
  
  public void drawCell(){
    strokeWeight(1);
    fill(255,255,255);
    rect(this.x,this.y,cellSize, cellSize);
    if(this.number>0){
      textSize(32);
      fill(0,0,0);
      text(""+this.number,this.x+15,this.y+38);
    }
  }
  
  public int getNumber(){return this.number;}
  public void changeNumber(int num){this.number = num;}
}

public class Game{
  private Cell[][] gameBoard;
  
  public Game(){
    gameBoard = new Cell[9][9];
    
    /********************************
     gameBoard[row][column] notation
    ********************************/
    
    for(int i=0; i<9; i++){
      for(int j=0; j<9; j++){
        Cell c = new Cell(j*50,i*50,0);
        gameBoard[i][j] = c;
      }
    }
    
    gameBoard[0][3].changeNumber(4);
  }
  
  public void drawBoard(){
    for(int i=0; i<9; i++){
      for(int j=0; j<9; j++){
        Cell c = gameBoard[i][j];
        c.drawCell();
        
      }
    }
  }
  
  public void textBoard(){
    for(int i=0; i<9; i++){
      for(int j=0; j<9; j++){
        Cell c = gameBoard[i][j];
        if(j%3==0){System.out.print(" |");}
        System.out.print(" "+c.getNumber());
      }
      if((i+1)%3==0){
        System.out.println();
        System.out.print(" -----------------------");
      }
      System.out.println();
      
    }
  }
}
