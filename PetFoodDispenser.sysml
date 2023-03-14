package PetFoodDispenser {
    import ScalarValues::*;
    import SI::*;
    import PDBehavior::*;
            
    package SchedulePartDef {
        part def Screen;
        part def Button;
    }

	enum def EvaluateIndex :> Integer {
		excellent = 4;
		good = 3;
		okay = 2;
		bad = 1;
	}

    part def Buckle;
    
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
        part redefines scheduler{
            attribute redefines mass = 50[g];
            attribute redefines cost = 20;
        }

        part redefines foodHopper{
            attribute redefines mass = 100[g];
            attribute redefines cost = 5;
        }

        part redefines monitor{
            attribute redefines cost = 20;
            attribute redefines mass = 20[g];
        }

        part redefines bowl {
			attribute redefines material = "304 stainless steel";
			attribute redefines mass = 80[g];
            attribute redefines cost = 6;
			attribute redefines tilt = 8;
		}

        part redefines charginsystem{
            attribute redefines mass = 500[g];
            attribute redefines cost = 10;
        }

		part redefines voiceRecorder {
            attribute redefines mass = 100[g];
            attribute redefines cost = 10;

	        attribute redefines maxTime = 10[s];
            attribute redefines mike: Mike {
                attribute volume = 60;
            }
	        attribute mass = 10[g];
	        part redefines buttons[1];
	    }

        part redefines base{
            attribute redefines mass = 100[g];
            attribute redefines cost = 5;
        }
    }
    
    part def Scheduler {
        attribute cost: Integer;
        attribute mass :> ISQ::mass;
        attribute dispensedPortions: Integer;
        attribute meetsPerDay: Integer;
        attribute reliabilityRatingScale : Integer;

        part screen: SchedulePartDef::Screen ;
        part dispenseButton: SchedulePartDef::Button;
        part voiceRecordButton: SchedulePartDef::Button;
        part scheduleButton: SchedulePartDef::Button[2];
    }

    part def FoodHopper{
        attribute cost: Integer;
        attribute mass :> ISQ::mass;
        attribute reliabilityRatingScale : Integer;


        attribute FoodDispensFlag : Boolean;
        attribute remainingFood : Real;
        attribute hopperCapacity: Real;
        attribute material: String;
        
        part tank: Tank;
        part lid: Lid;
        part buckle:Buckle;
        
        connect lid to tank; // Todo: other connection
        port foodInPort:HopperDef::FoodInPort;
        port fooddispensePort:HopperDef::DispensePort;

     perform action washHopper:Wash;
     perform action dispense:Dispense;
    
    }

	port def AssemblyPort;
    part def Base{
        attribute cost: Integer;
        attribute mass :> ISQ::mass;
    }
    part def Bowl{
        attribute cost: Integer;
        attribute mass :> ISQ::mass;

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
        attribute cost: Integer;
        attribute mass :> ISQ::mass;
        attribute reliabilityRatingScale : Integer;

        attribute maxTime: Integer;
        
        part buttons: SchedulePartDef::Button[1..4];
        part mike: Mike;
        
        port playSingalPort:ControlPort;  // connect to scheduler single port
        
        perform action recordVoice:RecordVoice;
        perform action mPlayVoice:ManuallyPlayVoice;
        perform action sPlayVoice:ScheduledPlayVoice;
    }
    part def Monitor{
        attribute cost: Integer;
        attribute mass :> ISQ::mass;

        attribute foodWeightRecord:Real; 
        attribute alertThreshold: Real;
        attribute isalerting:Boolean;
        perform action alert:Alert;
    } // To monitor how much food is dispensed
    
    part def ChargingSystem {
        // TODO
        attribute cost: Integer;
        attribute mass :> ISQ::mass;
        attribute reliabilityRatingScale : Integer;

        part adapter:DispenserAdpater;
        part batterySystem:BatterySystem;
        part powerSource:PowerSource;
    }
    part def PowerSource {
        attribute voltage : Real { constraint greater_than_zero; }
        attribute current : Real { constraint greater_than_zero; }
    }
    part def BatterySystem {
        attribute additionalCost: Integer;

        part battery:AdditionalBattery;
        part lowBatteryLight:LowBatteryLight;
    }
    part def LowBatteryLight {} // LED light to indicate low battery

    part def AdditionalBattery {
        attribute volume: Real;
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