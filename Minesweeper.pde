import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int unclicked = NUM_ROWS * NUM_COLS;
private GameOver ended;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here

  buttons = new MSButton [NUM_ROWS][NUM_COLS];
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      buttons [r][c] = new MSButton (r, c);
    }
  }

  setMines();
}

public void setMines() {
  for (int i = 0; i < (int)(NUM_ROWS*NUM_COLS*.1); i++) { 
    int r = (int)(Math.random()* NUM_ROWS);
    int c = (int)(Math.random()* NUM_COLS);
    if (mines.contains(buttons[r][c])) {
      i--;
    }
    mines.add (buttons [r][c]);
  }
}

public void draw ()
{
  background( 0 );
}

public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if (isValid(row-1, col-1) && mines.contains(buttons[row-1][col-1]))
    numMines++;
  if (isValid(row-1, col) && mines.contains(buttons[row-1][col]))
    numMines++;
  if (isValid(row-1, col+1) && mines.contains(buttons[row-1][col+1])) 
    numMines++;
  if (isValid(row, col-1) && mines.contains(buttons[row][col-1]))
    numMines++;
  if (isValid(row, col+1) && mines.contains(buttons[row][col+1]))
    numMines++;
  if (isValid(row+1, col-1) && mines.contains(buttons[row+1][col-1]) )
    numMines++;
  if (isValid(row+1, col) && mines.contains(buttons[row+1][col]) )
    numMines++;
  if (isValid(row+1, col+1) && mines.contains(buttons[row+1][col+1]) )
    numMines++;
  return numMines;
}
public class GameOver {
  private boolean winnin;
  public GameOver (boolean won) {
    winnin = won;
    Interactive.add( this ); // register it with the manager
  }

  public void draw ()
  {
    fill(200, 200, 200, 200);
    noStroke();
    ellipse(200, 200, 300, 300);
    if (!winnin) {
      displayLosingMessage();
    } else {
      displayWinningMessage();
    }
  }

  public void displayLosingMessage()
  {
    fill(0);
    text("you lose :[ ", 200, 200);
  }
  public void displayWinningMessage()
  {
    fill(0);
    text("mines swept!", 200, 200);
  }
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if(mouseButton == RIGHT){
      if(!flagged)
        flagged = true;
      else
        flagged = false;
      return;
    }
    if (clicked) {
      return;
    }
    if (mines.contains(buttons[myRow][myCol])) {
      clicked = true;
      ended = new GameOver(false);
      return;
    }
    if (countMines(myRow, myCol) > 0) {
      clicked = true;
      setLabel(countMines(myRow, myCol));
      unclicked--;
      if (mines.size() == unclicked){
        ended = new GameOver(true);
      }
      return;
    }
    clicked = true;
    unclicked --;
    if (isValid(myRow-1, myCol-1))
      buttons[myRow-1][myCol-1].mousePressed();
    if (isValid(myRow-1, myCol))
      buttons[myRow-1][myCol].mousePressed();
    if (isValid(myRow-1, myCol+1))
      buttons[myRow-1][myCol+1].mousePressed();
    if (isValid(myRow, myCol-1))
      buttons[myRow][myCol-1].mousePressed();
    if (isValid(myRow, myCol+1))
      buttons[myRow][myCol+1].mousePressed();
    if (isValid(myRow+1, myCol-1))
      buttons[myRow+1][myCol-1].mousePressed();
    if (isValid(myRow+1, myCol))
      buttons[myRow+1][myCol].mousePressed();
    if (isValid(myRow+1, myCol+1))
      buttons[myRow+1][myCol+1].mousePressed();
    if (mines.size() == unclicked){
      ended = new GameOver(true);
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(250,230,135);
    else if ( clicked && mines.contains(this) ) 
      fill(200, 75, 50);
    else if (clicked)
      fill( 180,150,100 );
    else 
    fill(180,210,155);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
