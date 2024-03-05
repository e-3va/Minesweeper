import de.bezier.guido.*;
int NUM_ROWS = 7;
int NUM_COLS = 7;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean gameOver = false;
void setup (){
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make(this);
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < buttons.length; r++){
      for (int c = 0; c < buttons[r].length; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
}
public void setMines(){
    mines.clear();
    int numMines = 3;
    while (mines.size() < numMines) {
        int ranRow = (int)(Math.random() * NUM_ROWS);
        int ranCol = (int)(Math.random() * NUM_COLS);
        MSButton newMine = buttons[ranRow][ranCol];
        if (!mines.contains(newMine)) {
            mines.add(newMine);
        }
    }
}

public void draw (){
    background(0);
    if (!gameOver && isWon()) {
        displayWinningMessage();
    }
    if (!gameOver && !isWon()) {
        displayLosingMessage();
    }
}
public boolean isWon(){
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            MSButton button = buttons[r][c];
            if (!mines.contains(button) && !button.clicked) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage(){
    for(MSButton mine : mines) {
        mine.clicked = true;
        mine.setLabel("You Lose!");
    }
    //noLoop();
    gameOver = true;
}
public void displayWinningMessage(){
    for(MSButton mine : mines){
        mine.clicked = true;
        mine.setLabel("You Win!");
    }
    //noLoop();
    gameOver = true;
}
public boolean isValid(int r, int c){
    if(r>=0 && c>= 0 && r<NUM_ROWS && c<NUM_COLS) return true;
    return false;
}
public int countMines(int row, int col){
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++){
      for(int c = col-1; c<=col+1;c++){
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
      }
    }return numMines;
}
public class MSButton{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col ){
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
    public void mousePressed () {
        clicked = true;
        if(mouseButton == RIGHT && flagged == false) 
          flagged = true;
        else if(mouseButton == RIGHT && flagged == true) 
          flagged = false;
        else if(mines.contains(this)) 
          displayLosingMessage();
        else if(countMines(myRow,myCol)> 0){
          int val = countMines(myRow, myCol);
          myLabel = Integer.toString(val);
        }
        else mousePressed();
    }
    public void draw () {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        myLabel = newLabel;
    }
    public void setLabel(int newLabel){
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged(){
        return flagged;
    }
}
