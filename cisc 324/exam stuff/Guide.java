

public class Guide extends Thread{
    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();
        
    
        synchronized (Stuff.class) {
            Stuff.a += 1;
            System.out.println("Guide played with a: " + Stuff.a);
        }
    }
    
}
