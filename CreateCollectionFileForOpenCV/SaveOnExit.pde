
// a rather ugly solution, but works great
// via: https://forum.processing.org/topic/run-code-on-exit

void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      try {
        
        // close the file
        output.flush();
        output.close();
        stop();
      } 
      catch (Exception e) {
        e.printStackTrace();     // not much else to do at this point...
      }
    }
  }
  ));
}
