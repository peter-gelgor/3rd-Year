import javax.sound.sampled.SourceDataLine;

// This file defines class "writer".

// This code uses
//      class Semaphore, from the java.util.concurrent package in Java 5.0 which defines the behaviour of a 
//                           semaphore, including acquire and release operations.
//      class Synch, which defines the semaphores and variables
//                   needed for synchronizing the readers and writers.
//      class RandomSleep, which defines the doSleep method.


public class Writer extends Thread {
  int myName;  // The variable myName stores the name of this thread.
               // It is initialized in the constructor for class Reader.

  RandomSleep rSleep;  // rSleep can hold an instance of class RandomSleep.



  // This is the constructor for class Writer.  It has an integer parameter,
  // which is the name that is given to this thread.
  public Writer(int name) {
    myName = name;  // copy the parameter value to local variable "MyName"
    rSleep = new RandomSleep();   // Create and instance of RandomSleep.
  }  // end of the constructor for class "Writer"



  public void run () {
    for (int I = 0;  I < 5; I++) {
      System.out.println("writerQueue = " + Stuff.writerQueue + " activeWriters = " + Stuff.activeWriters);

      // Get permission to write
      System.out.println("Writer " + myName + " wants to write");

      //block readers from reading
      try {
        Stuff.readBlock.acquire();
      } catch (InterruptedException e2) {
        // TODO Auto-generated catch block
        e2.printStackTrace();
      }

      //add to writer queue
      try {
        Stuff.mutex.acquire();
      } catch (InterruptedException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
      }
      Stuff.writerQueue ++;
      Stuff.mutex.release();
      try{

      	Stuff.wrt.acquire();
      }
      catch(Exception e){}

      //decrement the writer queue
      try {
        Stuff.mutex.acquire();
      } catch (InterruptedException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      Stuff.writerQueue --;
      Stuff.activeWriters ++;

      Stuff.mutex.release();


      // Simulate the time taken by writing.
      System.out.println("Writer " + myName + " is now writing, writerqueue = " + Stuff.writerQueue);
      rSleep.doSleep(1, 200);

      // We're done writing.  Signal the "wrt" semaphore.  If a Reader thread
      // was waiting on "wrt", that reader starts, and allows other waiting
      // readers (who are waiting on "mutex") to start as well.  If a Writer
      // thread was waiting on "wrt", then that writer goes next.  If no one
      // was waiting on wrt, then wrt has the value 1, so the next future
      // reader or writer can go without waiting.
      System.out.println("Writer " + myName + " is finished writing");
      Stuff.wrt.release();

      // subtract from active writers
      try {
        Stuff.mutex.acquire();
      } catch (InterruptedException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      Stuff.activeWriters --;
      Stuff.mutex.release();

      if (Stuff.activeWriters + Stuff.writerQueue < 1) {
        Stuff.readBlock.release();
      }
      


      // Simulate "doing something else"
      rSleep.doSleep(1, 1000);
    } // end of "for" loop
  }  // end of "run" method
}  // end of class "Writer"

