package FoodDispenserUserFriendlyVerfication {
    import ScalarValues::*;
	import SI::*;
	
	import PetFoodDispenser::*;
	
	requirement userFriendlySpecification{
    	subject foodDispenser; 
    	requirement <'1'> voiceRecordTimeRequirement {
    		doc /*The user shell be able to record voice of up to 10s */
    		attribute maxTimeRequired=10 [s];
    		attribute actualMaxTime = 10 [s];
    		assume constraint {maxTimeRequired==actualMaxTime}
    	}
    	requirement <'2'> voicePlayVolumeRequirement {
    		doc /* The volume shell set up as default in range [50, 60] decibels */
    		attribute volumeMaxRequired = 60;
    		attribute volumeMinRequired = 50;
    		attribute actualVolume: Integer;
    		assume constraint {volumeMinRequired<=actualVolume<=volumeMaxRequired}
    	}
    	requirement <'3'> recoderReliableRequirement;
    	requirement <'4'> bowlMaterialRequirement;
    	requirement bowlTiltRequirement;
    	requirement lockerRequirement;
    }
    
    
	// Test case for 10s voice record objective
    verification def VoiceRecordMaxTimeTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
			verify userFriendlySpecification.voiceRecordTimeRequirement;
		}
		return verdict: VerdictKind;
    }
    verification def VoiceRecordVolumeTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.voicePlayVolumeRequirement;
    	}
    	return verdict: VerdictKind;
    }
    verification def VoiceRecordReliabilityTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.recoderReliableRequirement;
    	}
    	return verdict: VerdictKind;
    }
    
    // Test case pet health objective
    verification def BowlMaterialTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.bowlMaterialRequirement;
    	}
    	return verdict: VerdictKind;
    }
    verification def BowlTiltTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.bowlTiltRequirement;
    	}
    	return verdict: VerdictKind;
    }
    verification def LockerTest{
    	subject foodDispenser:FoodDispenser; 
    	objective {
    		verify userFriendlySpecification.lockerRequirement;
    	}
    	return verdict: VerdictKind;
    }
    
    verification voiceRecordMaxTimeTest: VoiceRecordMaxTimeTest; // It's play by dispenser part: recoder, do query and match.
    verification voiceRecordVolumeTest: VoiceRecordVolumeTest; // ditto
    verification voiceRecordReliabilityTest: VoiceRecordReliabilityTest; // Need a actor, turn off the  power and try if the replay of voice work or not.
    
	verification bowlMaterialTest: BowlMaterialTest; // only part: bowl involved,  do query and match 
	verification bowlTiltTest: BowlTiltTest; // only part bowl involved, do query and match 
	verification lockerTest: LockerTest;  // need a actor. Test with different pulling forces
    
}

