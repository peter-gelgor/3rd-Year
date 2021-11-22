class Buffer 
{
   private char [] buffer;
   private int count = 0, in = 0, out = 0;

   Buffer(int size)
   {
      buffer = new char[size];
   }
 
   public synchronized void Put(char c) 
  {
     while(count == buffer.length) ;
     System.out.println("Producing " + c + " ...");
     buffer[in] = c; 
     in = (in + 1) % buffer.length; 
     count++;
   }
    
   public synchronized char Get() 
   {

     System.out.println("Am inside Get\n");
     while (count == 0) ;
     char c = buffer[out]; 
     out = (out + 1) % buffer.length;
     count--;
     System.out.println("Consuming " + c + " ...");
     return c;
   }
}

