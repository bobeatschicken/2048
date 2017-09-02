// The only keys (and corresponding keyCodes) that are used to control the game are:
// * RETURN (10)--Restarts game if Game Over is being displayed
// * LEFT ARROW (37)--Move blocks to the left
// * UP ARROW (38)--Move blocks up
// * RIGHT ARROW (39)--Move blocks right
// * DOWN ARROW (40)--Move blocks down
// * Upper-case 'U' (85)--Undo (revert one keypress)

void keyPressed() {
  if (grid.isGameOver()) {
    // If RETURN is pressed, then start a fresh game with one block
    if (keyCode == 10) { 
      grid.initBlocks();
      grid.placeBlock();
    } 
    return;
  }
  
  // If a key is pressed and it isn't LEFT (arrow), RIGHT, UP, DOWN, or U,
  // then ignore it by returning immediately
  if (!(isBetween(keyCode, 37, 40) || keyCode == 85)) return;

  if (keyCode == 85) {  // ASCII value for upper case U (for Undo)
     grid.gridCopy(backup_grid);  
     return;
  }
  
  DIR dir;
  DIR[] dirs = { DIR.WEST, DIR.NORTH, DIR.EAST, DIR.SOUTH };

  dir = dirs[keyCode-37];
  
  if (!grid.someBlockCanMoveInDirection(dir)) return;
  else gameUpdate(dir);
}