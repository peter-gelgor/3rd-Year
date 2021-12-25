public class Driver {
    public static void main(String[] args) {
        Guide g = new Guide();
        Tourist t = new Tourist();
        t.start();
        g.start();
    }
}
