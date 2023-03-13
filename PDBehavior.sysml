package PDBehavior {
    import ScalarValues::*;
  
    action def PutButton { out cmd : Integer; }
    action def HoldButton { out cmd: Integer; }
    action def SendPlaySignal { out cmd: Integer; }
    action def Record{
        in icmd: Integer;
        in stopSignal: Boolean;  
        attribute recordTime: Integer;
        out cmd: Integer;
    }
    action def PlayVoice{
        in icmd: Integer;
    }
    action def FinishNotification{
        in cmd: Integer;
    }

    action def ManuallyDispenseFood{
        first start;
    
        then merge continueOpening;

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
    action def RecordVoice {
        first start;

        then action holdButton: HoldButton;

        

        then action record: Record{
            in cmd = holdButton.cmd;
            in stopSignal = pressButton.cmd;
        }

        

        then decide;
            if record.recordTime >= 10 then finishNotification;
            if record.stopSignal then finishNotification;

        action finishNotification: FinishNotification{
            in cmd = record.cmd;
        }

        then done;

        action pressButton: PutButton;
    }
    
    action def ManuallyPlayVoice{
        first start;
        then action pressButton: PutButton;
        then action speak: PlayVoice{
            in cmd = pressButton.cmd;
        }

        then done;
    }
    action def ScheduledPlayVoice{ // triggered by scheduler singal
        first start;
        then action signal: SendPlaySignal;
        then action speak: PlayVoice {
            in cmd = signal.cmd;
        }
        then done;
    }

}