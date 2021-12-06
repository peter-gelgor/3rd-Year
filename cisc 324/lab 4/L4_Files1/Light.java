public class Light extends Thread {
   public Light(){
       Synch.timeSim.threadStart();
   }

   public void run () {
		 
    while (Synch.traffic){
        
       try {
           Synch.mutex.acquire();
       } catch (Exception e){}
       System.out.println("East light = green.");

       Synch.light = 1;
       for (int i = 0; i <Synch.eastCars; i++){
           Synch.east.release();
       }
       Synch.mutex.release();
       Synch.timeSim.doSleep(200);
       System.out.println("Both lights = red.");

       Synch.light= 0;
       Synch.timeSim.doSleep(100);
       
       try {
           Synch.mutex.acquire();
       } catch (Exception e){}
       System.out.println("West light = green.");

       Synch.light = 2;
       for (int i = 0; i <Synch.westCars; i++){
           Synch.west.release();
       }	
       
       Synch.mutex.release();
       Synch.timeSim.doSleep(200);
       System.out.println("Both lights = red.");

       Synch.light= 0;
       Synch.timeSim.doSleep(100);
       
    }
    Synch.timeSim.threadEnd();
}

    
}
