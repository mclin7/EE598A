package PDBehavior {
    import ScalarValues::*;
  

    action def ManuallyDispenseFood{
        first start;
    
        then merge continueOpening;
        action def PutButton { out cmd : Integer; }

        then action monitor: PutButton;

        then decide;
          if monitor.cmd == 1 then open;
          if monitor.cmd == 0 then endOpen;

        action open : DispenserOpen{
            in cmd = monitor.cmd;
        }
        then continueOpening;

        action endOpen :EndOpen;

        then done;

        item def Food;
        action def EndOpen;
        action def DispenserOpen {
            in cmd: Integer;
        }
        
    }

}