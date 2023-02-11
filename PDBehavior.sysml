package PDBehavior {
    import ScalarValues::*;
    
    action ManuallyDispenseFood{
        first start;
    
        then merge continueOpening;
        action def PubButton { out cmd : Integer; }

        then action monitor : PubButton{
            out cmd: Real;
        }

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