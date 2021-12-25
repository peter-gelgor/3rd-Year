public class Tourist extends Thread {
    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();
        synchronized(Stuff.class){
            Stuff.a -= 1;
            System.out.println("Tourist changed a, a = " + Stuff.a);
        }
        
    }
}