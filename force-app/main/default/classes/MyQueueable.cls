public class MyQueueable implements Queueable {
    private List<Integer> integerList;
    
    public MyQueueable(List<RequestWrapper> wrapperList ) {
        this.integerList = integerList;
    }
    
    public void execute(QueueableContext context) {
        // Do something with the integerList parameter
        for (Integer i : integerList) {
            System.debug(i);
        }
    }
}