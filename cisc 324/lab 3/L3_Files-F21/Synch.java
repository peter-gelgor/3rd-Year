// This file defines class "Synch".  This class contains all the semaphores
// and variables needed to coordinate the instances of the Reader and Writer
// classes.  

import java.util.concurrent.*;

public class Synch {

  public static Semaphore mutex;
  //semaphore to block new readers when writers are in line
  public static Semaphore readBlock;
  public static Semaphore wrt;
  public static int readcount = 0;
  public static int activeWriters = 0;
  public static int readerQueue = 0;
  public static int writerQueue = 0;


}  // end of class "Synch"

