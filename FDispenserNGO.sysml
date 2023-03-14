/** Contains definitions used when connecting 
 * Needs/Goals/Objectives to each other and to requirements
 */
package FDispenserNGO {
	import FDFriendlyVerfication::*;
	
	import ScalarValues::*;
	import SI::*;
	
	
	abstract part def DesignElement {
		attribute text:String;		
	}
	
	part def Conops :> DesignElement;
	
	part def Need :> DesignElement;
	
	part def Goal :> DesignElement;
	
	allocation def NeedToConops {
		end need : Need;
		end conops : Conops;
	}
	
	allocation def GoalToNeed {
		end goal : Goal;
		end need : Need;
	}

	allocation def ReqToGoal {
		end req : FoodDispenserRequirement;
		end goal : Goal;
	}

	allocation def ReqToNeed {
		end req : FoodDispenserRequirement;
		end need : Need;
	}

    // conops
	part voiceRecorderConops : Conops {
		attribute :>>  text = "The pet owner can record the voice and the dispenser will play the voice when dispensing food. ";
	}

	part voiceRecordandPlayNeed: Need {
		attribute :>> text = "Customers can record voices to play during dispensed food.";
	}

	part stayConnectedGoal : Goal {
		attribute :>>  text = "Customers want to stay connected with pets, enhancing the bond with your pet by keeping him fed regularly and feel safe & well cared for";
	}

	part petHealthyConOps : Conops {
		attribute :>> text = "The pet can use the pet food dispenser for a long time and should not cause health issues";
	}
	
	part healthGuaranteeNeed : Need {
		attribute :>> text = "The feeder must not be harmful to the animal's health";
	}
	
	part healthGoal: Goal{
		attribute :>> text = "No feline acne or whisker stress or obesity";
	}

	// zyxing : charger system
	part chargerBatteryConOps : Conops {
		attribute :>> text = "The owner can use the DC adapter to power the dispenser. As an option, the user can pay more to get a dispenser that has dual power choice.";
	}

	part longivityNeed : Need{
		attribute :>> text = "use it for a long period of time";
	}

	part longivityGoal : Goal{
		attribute :>> text = "The pet owner can use one dispenser for a long time without worrying about it breaking or malfunctioning in daily usage.";
	}
	// allocate needs to conops
	allocation recorderVoice : NeedToConops 
		allocate voiceRecordandPlayNeed to voiceRecorderConops;
	
	allocation stayConnected: GoalToNeed
	    allocate voiceRecordandPlayNeed to stayConnectedGoal;

	allocation beHealth: GoalToNeed
		allocate healthGoal to healthGuaranteeNeed;

	// allocate requirements to needs
	// allocate requirements to goals

	allocation timeToRecoder: ReqToNeed 
		allocate userFriendlySpecification.voiceRecordTimeRequirement to voiceRecordandPlayNeed;
	
	allocation volumeToRecoder: ReqToNeed
	    allocate userFriendlySpecification.voicePlayVolumeRequirement to voiceRecordandPlayNeed;

	allocation reliablilityToRecoder: ReqToNeed
	    allocate userFriendlySpecification.recoderReliableRequirement to voiceRecordandPlayNeed;
	
	allocation MaterialToBowl: ReqToNeed
	    allocate userFriendlySpecification.bowlMaterialRequirement to healthGuaranteeNeed;

    allocation designToBowl: ReqToNeed
        allocate userFriendlySpecification.bowlTiltRequirement to healthGuaranteeNeed;
    	
	allocation lookToHopper: ReqToNeed
	    allocate userFriendlySpecification.lockerRequirement to healthGuaranteeNeed;

	
}