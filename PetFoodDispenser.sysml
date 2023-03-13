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
    
    perform action manuallyDispenseFood[*] : ManuallyDispenseFood;
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
        part base: Base;
    }
    
    // mass/cost
    part foodDispenser: FoodDispenser{
        part redefines bowl {
			attribute redefines material = "304 stainless steel";
			attribute redefines mass = 30[g];
			attribute redefines tilt = 8;
		}
		part redefines voiceRecorder {
	        attribute redefines maxTime = 10[s];
            attribute redefines mike: Mike {
                attribute volume = 60;
            }
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
        attribute FoodDispensFlag : Boolean;
        attribute remainingFood : Real;
        attribute hopperCapacity: Real;
        attribute material: String;
        
        part tank: Tank;
        part lid: Lid;
        part buckle:Buckle;
        
        connect lid to tank; // Todo: other connection
        port foodInPort:FoodInPort;
        port fooddispensePort:DispensePort;

     perform action washHopper:Wash;
     perform action dispense:Dispense;
    
    }

	port def AssemblyPort;
    part Base;
    part def Bowl{
    	attribute material: String;
    	attribute mass:>ISQ::mass;
    	attribute tilt:Integer;  // tilt degree

    	port bulgingPort:AssemblyPort;  // used to connect with the PetFoodDispenser hopper
    }
    item def DesiccantBag;
    item def Food{            
        attribute foodMass:>ISQ::mass;
    }
    
    part def Lid{
        attribute lidStatus: Boolean;
        attribute sealStatus: Boolean;
        attribute material: String;
        part holder: DesiccantBagHolder;
        item dbag: DesiccantBag;
    }
    part def DesiccantBagHolder;
    part def Mike{
        attribute volume: Integer;
    }
    
    port def ControlPort;
    part def Tank;
    abstract part def DCAdapter {
        part cable: Cable;
    }
    

    part def VoiceRecorder {
        attribute maxTime: Integer;
        
        part buttons: SchedulePartDef::Button[1..4];
        part mike: Mike;
        
        port playSingalPort:ControlPort;  // connect to scheduler single port
        
        perform action recordVoice:RecordVoice;
        perform action mPlayVoice:ManuallyPlayVoice;
        perform action sPlayVoice:ScheduledPlayVoice;
    }
    part def Monitor{
         attribute foodWeightRecord:Real; 
         attribute alertThreshold: Real;
         attribute isalerting:Boolean;
         perform action alert:Alert;
    } // To monitor how much food is dispensed
    
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