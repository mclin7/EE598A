package petFoodDispenser {
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
    perform action recordVioce; // TBD
    perform action autmaticDispenseFood;  // TBD
	perform action refill;  // TBD
	
    
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
    
    part def Monitor; // To monitor how much food is dispensed
    
    
    part def DispenserAdpater:> DCAdapter {
        part redefines cable {
            attribute redefines length = 1.49[m];
        }
    }
    part def Cable{
        attribute length: Real;
    }
    

}