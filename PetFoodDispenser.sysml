package PetFoodDispenser {
    import ScalarValues::*;
    import SI::*;
    import PDBehavior;
    
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
    
    perform action manuallyDispenseFood[*] :> PDBehavior::ManuallyDispenseFood;
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
    	// do redefines
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

    part def Bowl;
    item def DesiccantBag;
    item def Food{            
    	attribute foodMass:>ISQ::mass;
    }
    
    part def Lid{
        part holder: DesiccantBagHolder;
        item dbag: DesiccantBag;
    }
    part def DesiccantBagHolder;
    
    part def Tank;
    abstract part def DCAdapter {
        part cable: Cable;
    }
    part def VoiceRecorder {
        attribute volume: Integer;
        attribute maxTime: Integer;	
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
    

    
}