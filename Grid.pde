public class Grid {
  Block[][] block;
  private final int COLS;
  private final int ROWS;
  private int score = 0;
  
  public Grid(int cols, int rows) {
    COLS = cols;
    ROWS = rows;
    block = new Block[COLS][ROWS];
    initBlocks();  // initializes all blocks to empty blocks
  }
    
  public Block getBlock(int col, int row) {
    return block[col][row];
  }
  
  public void setBlock(int col, int row, int value, boolean changed) {
    block[col][row] = new Block(value, changed);
  }
  
  public void setBlock(int col, int row, int value) {
    setBlock(col, row, value, false);
  }
  
  public void setBlock(int col, int row) {
    setBlock(col, row, 0, false);
  }
  
  public void setBlock(int col, int row, Block b) {
    block[col][row] = b;
  }
  
  public void initBlocks() {
    for (int col = 0; col < COLS; col++) {
      for (int row = 0; row < ROWS; row++) {
        setBlock(col, row);
      }
    }
  }
  
  public boolean isValid(int col, int row) {
    if (col < COLS && col >= 0 && row < ROWS && row >= 0){
      return true;
    } else{
      return false;
    }
  }
  
  public void swap(int col1, int row1, int col2, int row2) {
    Block block1 = getBlock(col1, row1);
    Block block2 = getBlock(col2, row2);
    setBlock(col2, row2, block1);
    setBlock(col1, row1, block2);
  }
  
  public boolean canMerge(int col1, int row1, int col2, int row2) {
    Block block1 = getBlock(col1, row1);
    Block block2 = getBlock(col2, row2);
    if (block1.getValue() == block2.getValue() && !block1.isEmpty() && !block2.isEmpty()){
      return true;
    } else {
      return false;
    }
  }
  
  public void clearChangedFlags() {
    for(int col = 0; col < COLS; col++) {
      for(int row = 0; row < ROWS; row++) {
        block[col][row].setChanged(false);
      }
    }
  }
 
  // Is there an open space on the grid to place a new block?
  public boolean canPlaceBlock() {
    if (getEmptyLocations().size() > 0) {
      return true;
    } else {
      return false;
    }
  }
  
  public ArrayList<Location> getEmptyLocations() {
    ArrayList<Location> emptyLocations = new ArrayList<Location>();
    for (int col = 0; col < COLS; col++) {
      for (int row = 0; row < ROWS; row++) {
        if (block[col][row].isEmpty()) {
          emptyLocations.add(new Location (col, row));
        } 
      }
    }
    return emptyLocations;
  }
  
  public Location selectLocation(ArrayList<Location> locs) {
    int index = int (random(0, locs.size()));
    
    return locs.get(index);
  }
  
  // Randomly select an open location to place a block.
  public void placeBlock() {
    ArrayList<Location> locs = getEmptyLocations();
    
    Location location = new Location(selectLocation(locs).getCol(), selectLocation(locs).getRow());
    
    int random = int(random(1, 9));
    if (random <= 7 && block[location.getCol()][location.getRow()].isEmpty()) {
      setBlock(location.getCol(), location.getRow(), 2);
    } else if (random == 8 && block[location.getCol()][location.getRow()].isEmpty()){
      setBlock(location.getCol(), location.getRow(), 4);
    } else {
      placeBlock();
    }
    
  }
  
  // Are there any adjacent blocks that contain the same value?
  public boolean hasCombinableNeighbors() {
    int comparableNeighbors = 0;
    for (int col = 1; col < COLS - 1; col++) {
      for (int row = 1; row < ROWS - 1; row++) {
        if (canMerge(col, row, col-1, row) || 
        canMerge(col, row, col+1, row) || 
        canMerge(col, row, col, row-1) || 
        canMerge(col, row, col, row+1)) {
          comparableNeighbors++;
        }
      }
    }
    if (canMerge(0, 0, 1, 0) || 
    canMerge(0, 0, 0, 1) ||
    canMerge(COLS-1, 0, COLS-2, 0) ||
    canMerge(COLS-1, 0, COLS-1, 1) ||
    canMerge(COLS-1, ROWS-1, COLS-1, ROWS-2) ||
    canMerge(COLS-1, ROWS-1, COLS-2, ROWS-1) ||
    canMerge(0, ROWS-1, 0, ROWS-2) ||
    canMerge(0, ROWS-1, 1, ROWS-1)) {
      comparableNeighbors++;
    }
    if (comparableNeighbors > 0) {
      return true;
    } else {
      return false;
    }
  }
  
   

  public boolean someBlockCanMoveInDirection(DIR dir) {
    boolean canMove = false;
    if (dir == DIR.NORTH) {
      for (int col = 0; col < COLS; col++) {
      for (int row = ROWS - 1; row > 0; row--) {
        if (canMerge(col, row, col, row-1) || (!block[col][row].isEmpty() && block[col][row-1].isEmpty())) {
          canMove = true;
          break;
        }
      }
    }
     return canMove;
    } else if (dir == DIR.EAST) {
      for (int col = 0; col < COLS - 1; col++) {
        for (int row = 0; row < ROWS; row++) {
          if (canMerge(col, row, col+1, row) || (!block[col][row].isEmpty() && block[col+1][row].isEmpty())) {
            canMove = true;
            break;
          } 
        }
      }

      return canMove;
    } else if (dir == DIR.SOUTH) {
      for (int col = 0; col < COLS; col++) {
        for (int row = 0; row < ROWS - 1; row++) {
          if (canMerge(col, row, col, row+1) || (!block[col][row].isEmpty() && block[col][row+1].isEmpty())) {
            canMove = true;
            break;
          }
        }
      }
      return canMove;
    } else if (dir == DIR.WEST) {
      for (int col = COLS-1; col > 0; col--) {
        for (int row = 0; row < ROWS; row++) {
          if (canMerge(col, row, col-1, row) || (!block[col][row].isEmpty() && block[col-1][row].isEmpty())) {
          //  System.out.println("canMove");
            canMove = true;
            break;
          }
        }
      }
      return canMove;
    } else {
      return canMove;
    }
  }

  
  // Computes the number of points that the player has scored
  public void computeScore() {
    int gameScore = 0;
    for (int col = 0; col < COLS; col++) {
      for (int row = 0; row < ROWS; row++) {
        gameScore += block[col][row].getValue();
      }
    }
    score = gameScore;
  }
  
  public int getScore() {
    return score;
  }
  
  public void showScore() {
      textFont(scoreFont);
      fill(#000000);
      text("Score: " + getScore(), width/2, SCORE_Y_OFFSET);
      textFont(blockFont);
  }
  
  public void showBlocks() {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        Block b = block[col][row];
        if (!b.isEmpty()) {
          float adjustment = (log(b.getValue()) / log(2)) - 1;
          fill(color(242 , 241 - 8*adjustment, 239 - 8*adjustment));
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
          fill(color(108, 122, 137));
          text(str(b.getValue()), GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col + BLOCK_SIZE/2, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row + BLOCK_SIZE/2 - Y_TEXT_OFFSET);
        } else {
          fill(BLANK_COLOR);
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
        }
      }
    }
  }
  
  // Copy the contents of another grid to this one
  public void gridCopy(Grid other) {
    block = other.block;
  }
  
  public boolean isGameOver() {
    if (!someBlockCanMoveInDirection(DIR.NORTH) && !canPlaceBlock() && !hasCombinableNeighbors()) {
      return true;
    } else if (!someBlockCanMoveInDirection(DIR.EAST) && !canPlaceBlock() && !hasCombinableNeighbors()) {
      return true;
    } else if (!someBlockCanMoveInDirection(DIR.SOUTH) && !canPlaceBlock() && !hasCombinableNeighbors()) {
      return true;
    } else if (!someBlockCanMoveInDirection(DIR.WEST) && !canPlaceBlock() && !hasCombinableNeighbors()) {
      return true;
    } else {
      return false;
    }
  }
  
  public void showGameOver() {
    fill(#0000BB);
    text("GAME OVER", GRID_X_OFFSET + 2*BLOCK_SIZE + 15, GRID_Y_OFFSET + 2*BLOCK_SIZE + 15);
  }
}