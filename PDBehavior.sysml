package PDBehavior {
    import ScalarValues::*;
    import SI::*;
  
    action def PutButton { out cmd : Integer; }
    action def HoldButton { out cmd: Integer; }
    action def StopPutButton{out cmd:Integer;}
    action def Readweigh {out weight:Real;}
    action def ProcessWdata{in data:Real;}
    action def Sendmessage {out cmd:Integer;}
    action def StopSending{out cmd:Integer;}
    action def HopperDismount;
    action def LowBatterySignal{ out signal:Integer;}
    action def ChargingSignal{ out signal:Integer;}
    action def ConnectWithPW{ out signal:Integer;}

    action def SendPlaySignal { out cmd: Integer; }
    action def chargingSignal { out cmd: Integer; }
    action def ReadBattery { out battery : Integer; }
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
        
    action def Wash//Triggered when buckle is push-up, stop when buckle push-down by user
    {
        first start;
    
        then merge continueOpening;

        then action hopper: PutButton;

        then decide;
          if hopper.cmd == 1 then hopperdismount;
          if hopper.cmd == 0 then mount;

        action hopperdismount : HopperDismount{
            in cmd = hopper.cmd;
        }
        then continueOpening;

        action mount :Mount;

        then done;

        action def Mount;
        action def DusMount {
            in cmd: Integer;
        }
        
      action def RefillFood {
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
    }
    action def Alert{ //triggered when food mount less than the threhold,
        first start;
        then merge continue;
        then action readweigh:Readweigh;
        then action processWdata:ProcessWdata{
           in data= readweigh.weight;
        }
        then decide;
            if processWdata.data<=30[g] then sendmessage;
            if processWdata.data>30[g] then stopsending;
        
        then continue;
        action sendmessage:Sendmessage{
        	out cmd=1;
        }
        action stopsending:StopSending{
        	out cmd=0;
        }
      
    }

    action def Charging{
        first start;
        then merge continue;
        then action connectWithPW:ConnectWithPW;
        then action processWdata:ProcessWdata{
            in data= connectWithPW.signal;
        }
        then decide;
            if processWdata.data == 0 then notCharging;
            if processWdata.data == 1 then chargingNow;

        then continue;

        action chargingNow:ChargingSignal{
            out signal=1;
        }
        action notCharging:ChargingSignal{
            out signal=0;
        }

        then action lowBatteryCheck:lowBatteryLightAlert;
    }

    action def lowBatteryLightAlert{
        first start;
        then merge continue;
        then action readBattery:ReadBattery;
        then action processWdata:ProcessWdata{
            in data= readBattery.battery;
        }
        then decide;
            if processWdata.data <= 20 then lightLowBatterySignal;
            if processWdata.data > 20 then stopLowBatterySignal;

        action lightLowBatterySignal:LowBatterySignal{
            out signal=1;
        }
        action stopLowBatterySignal:LowBatterySignal{
            out sigal=0;
        }
        then done;
    }

    action def Dispense;

}