public class HelloWorld {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("Hello, DevOps from Java!");
        while (true) {
            Thread.sleep(10000); // Sleep to keep container alive
        }
    }
}
