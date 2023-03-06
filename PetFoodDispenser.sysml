package PetFoodDispenser {
    import ScalarValues::*;
    import SI::*;
    import PDBehavior::*;
            
    package SchedulePartDef {
        part def Screen;
        part def Button;
    }
    
    package HopperDef {
        port def FoodInPort {
            in item foodSupply: Food;
        }
    
        port def DispensePort {
            out item foodSupply: Food;
        }
    }
    
    perform action manuallyDispenseFood[*] :> ManuallyDispenseFood;
    perform action recordVioce; // TBD long push recording/ click place
    perform action autmaticDispenseFood;  // TBD 
    perform action refill;  // TBD open lid, put food, state to filled, lock the lid
    
    part def FoodDispenser {
        part scheduler: Scheduler;
        part foodHopper: FoodHopper;
        part bowl: Bowl;
        part monitor: Monitor;
        part charginsystem: ChargingSystem;
        part voiceRecorder: VoiceRecorder;
    }
    
    part foodDispenser: FoodDispenser{
        part redefines bowl {
			attribute redefines material = '304 stainless steel';
			attribute redefines mass = 30[g];
			attribute redefine tilt = 8;
		}
		part redefines voiceRecorder {
	        attribute redefines volume = 60;
	        attribute redefines maxTime = 10[s];
	        attribute mass = 10[g];
	        part redefines buttons[1];
	    }
	   
    }
    
    part def Scheduler {
   
        attribute dispensedPortions: Integer;
        attribute meetsPerDay: Integer;
        part screen: SchedulePartDef::Screen ;
        part dispenseButton: SchedulePartDef::Button;
        part voiceRecordButton: SchedulePartDef::Button;
        part scheduleButton: SchedulePartDef::Button[2];
    }

    part def FoodHopper{
        attribute remainingFood : Integer;
        part tank: Tank;
        part lid: Lid;
        
        connect lid to tank; // Todo: other connection
        port foodInPort: HopperDef::FoodInPort;
        port fooddispensePort: HopperDef::DispensePort;
    
    }

	port def AssemblyPort
    part def Bowl{
    	attribute material: String;
    	attribute mass:>ISQ::mass;
    	attribute tilt:Integer:  // tilt degree

    	port bulgingPort:AssemblyPort;  // used to connect with the PetFoodDispenser hopper
    }
    item def DesiccantBag;
    item def Food{            
        attribute foodMass:>ISQ::mass;
    }
    
    part def Lid{
        part holder: DesiccantBagHolder;
        item dbag: DesiccantBag;
    }
    part def DesiccantBagHolder;
    part def Mike;
    
    port def ControlPort;
    part def Tank;
    abstract part def DCAdapter {
        part cable: Cable;
    }
    

    part def VoiceRecorder {
        attribute volume: Integer;
        attribute maxTime: Integer;
        
        part buttons: SchedulePartDef::Button[1..4];
        part mike:Mike;
        
        port playSingalPort:ControlPort;  // connect to scheduler single port
        
        perform action recordVoice:RecordVoice;
        perform action mPlayVoice:ManuallyPlayVoice;
        perform action sPlayVoice:SchedulePlayVoice;
    }
    part def Monitor; // To monitor how much food is dispensed
    
    part def ChargingSystem {
        // TODO
        part adapter:DispenserAdpater;
    }
    part def DispenserAdpater:> DCAdapter {
        part redefines cable {
            attribute redefineslength = 1.49[m];
        }
    }
    part def Cable{
        attribute length: Real;
    }
    
    analysis def DualPowerAnalysis{
        return isRemoteBetter : Boolean;
        objective LocalOrRemoteCtlAnalysisObjective {
            doc /* determine whether to provide a mobile contoller
             * for the pet food dispenser. 
             * The development of mobile app raises up the overall cost but have a better user experience
             * which may conflict with the cost requirement.
             */
        }
    }

    
}