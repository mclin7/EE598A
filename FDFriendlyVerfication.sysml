package FDFriendlyVerfication {
    import ScalarValues::*;
	import SI::*;
	import VerificationCases::*;
	
	import PetFoodDispenser::*;
	
	requirement def FoodDispenserRequirement;
	
	requirement userFriendlySpecification{
    	subject foodDispenser; 
    	requirement <'1'> voiceRecordTimeRequirement: FoodDispenserRequirement {
    		doc /*The user shell be able to record voice of up to 10s */
    		attribute maxTimeRequired = 10;
    		attribute actualMaxTime = 10;
    		assume constraint {maxTimeRequired==actualMaxTime}
    	}
    	requirement <'2'> voicePlayVolumeRequirement: FoodDispenserRequirement {
    		doc /* The volume shell set up as default in range [50, 60] decibels */
    		attribute volumeMaxRequired = 60;
    		attribute volumeMinRequired = 50;
    		attribute actualVolume: Integer;
    		assume constraint {volumeMinRequired<=actualVolume<=volumeMaxRequired}
    	}
    	requirement <'3'> recoderReliableRequirement: FoodDispenserRequirement;
    	requirement <'4'> bowlMaterialRequirement: FoodDispenserRequirement;
    	requirement bowlTiltRequirement: FoodDispenserRequirement;
    	requirement lockerRequirement: FoodDispenserRequirement;
		requirement <'7'> temperatureRequirement: FoodDispenserRequirement {
			doc /* The device shall work well between [-20, 40] degree */
			attribute temperatureMinRequired = -20;
			attribute temperatureMaxRequired = 40;
			attribute actualTemp: Integer;
			assume constraint {temperatureMinRequired<=actualTemp<=temperatureMaxRequired}
		}
		requirement <'8'> kibbleSizeRequirement:FoodDispenserRequirement {
			doc /* The kibble shall between 2 - 10 mm */
			attribute kibbleMaxSize = 10;
			attribute kibbleMinSize = 2;
			attribute actualKibbleSize: Integer;
			assume constraint {kibbleMinSize<=actualKibbleSize<=kibbleMaxSize}
		}
		requirement <'9'> setupStepRequirement: FoodDispenserRequirement {
			attribute expectedSteps = 3;
			attribute acutalSteps: Integer;
		}
		requirement <'10'> powerStandardRequirement: FoodDispenserRequirement {
			doc /* 5v DC */
			attribute adapter = 5;
		}
		requirement <'11'> foodAccessibilityRequirement: FoodDispenserRequirement;
		requirement <'12'> movabilityRequirement: FoodDispenserRequirement;
    }
    
    
   
	// Test case for 10s voice record objective
    verification def VoiceRecordMaxTimeTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
			verify userFriendlySpecification.voiceRecordTimeRequirement;
		}
		return verdict: Boolean;
    }
    
    // Temperature test
    verification def TemperatureTest{
    	subject foodDispenser:FoodDispenser;
		objective {
			verify userFriendlySpecification.temperatureRequirement;
		}
		return verdict: Boolean;
    }

	verification def KibbleSizeTest{
		subject foodDispenser:FoodDispenser;
		objective {
			verify userFriendlySpecification.kibbleSizeRequirement;
		}
		return verdict: Boolean;
	}

	verification def SetupStepsTest{
		subject foodDispenser:FoodDispenser;
		objective {
			verify userFriendlySpecification.setupStepRequirement;
		}
		return verdict: Boolean;
	}
    
    verification def MovabilityTest{
    	subject foodDispenser:FoodDispenser;
    	objective {
    		verify userFriendlySpecification.movabilityRequirement;
    	}
		return verdict: Boolean;
    }

	verification def PowerStandardTest{
		subject foodDispenser:FoodDispenser;
		objective {
    		verify userFriendlySpecification.powerStandardRequirement;
    	}
		return verdict: Boolean;
	}

	verification def FoodAccessibilityTest{
		subject foodDispenser:FoodDispenser;
		objective {
			verify userFriendlySpecification.foodAccessibilityRequirement;
		}
		return verdict: Boolean;
	}
    
    verification def VoiceRecordVolumeTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.voicePlayVolumeRequirement;
    	}
    	return verdict: Boolean;
    }
    verification def VoiceRecordReliabilityTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.recoderReliableRequirement;
    	}
    	return verdict: Boolean;
    }
    
    // Test case pet health objective
    verification def BowlMaterialTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.bowlMaterialRequirement;
    	}
    	return verdict: Boolean;
    }
    verification def BowlTiltTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.bowlTiltRequirement;
    	}
    	return verdict: Boolean;
    }
    verification def LockerTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.lockerRequirement;
    	}
    	return verdict: Boolean;
    }
    
    verification voiceRecordMaxTimeTest: VoiceRecordMaxTimeTest; // It's play by dispenser part, recoder, do query and match.
    verification voiceRecordVolumeTest: VoiceRecordVolumeTest; // ditto
    verification voiceRecordReliabilityTest: VoiceRecordReliabilityTest; // Need a actor, turn off the  power and try if the replay of voice work or not.
    verification bowlMaterialTest: BowlMaterialTest; // only part: bowl involved,  do query and match 
    verification bowlTiltTest: BowlTiltTest; // only part bowl involved, do query and match 
    verification lockerTest: LockerTest;  // need a actor. Test with different pulling forces(1 pound/3 pound/6pound)
    verification temperatureTest: TemperatureTest; // Place the dispenser in different temperature environment 
    verification movabilityTest: MovabilityTest; // Have a middle-age-person tried to move the dispenser see if it's easily movable
    verification kibbleSizeTest: KibbleSizeTest; // Test with oversize and smallsize kibble to test the functionality
    verification setupStepsTest: SetupStepsTest; // Have a person (age 15 - 25) try to setup the dispenser to see if statisfy 3 steps
    verification powerStandardTest: PowerStandardTest; // Test with 5v DC power with basic functionality
    verification foodAccessibilityTest: FoodAccessibilityTest; // Having different size/kind pet to test the accessibility of the food
}

