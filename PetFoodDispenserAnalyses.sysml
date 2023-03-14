package PetFoodDispenserAnalyses{
	import Parts::*;
    import ScalarValues::*;

	/** see in teamP Analysis List  */
	action def AnalysisAction{
		attribute oslcUri: String;
	}
	action voiceRecorderFriendlyAnalysis : AnalysisAction {
		redefines oslcUri = "team3/userexperience/voiceRecorderFriendlyAnalysis";
	}
	
	action voiceRecorderSystemComplexityAnalysis : AnalysisAction{
		redefines oslcUri = "team3/cost/voiceRecorderSystemComplexityAnalysis";
	}
	action bowlMaterialHealthyAnalysis: AnalysisAction{
		redefines oslcUri = "team3/userexperience/bowlMaterialHealthyAnalysis";
	}
	
	action structureComplexityAnalysis : AnalysisAction{
		redefines oslcUri = "team3/cost/structureComplexityAnalysis";
	}
	
	action saftyAnalysis : AnalysisAction{
		redefines oslcUri = "team3/userexperience/saftyAnalysis";
	}
	
	action portabilityAnalysis : AnalysisAction{
		redefines oslcUri = "team3/userexperience/portabilityAnalysis";
	}
	
	action MonitorcostAnalysis:AnalysisAction{
		redefines oslcUri = "team3/userexperience/MonitorcostAnalysis";
	}
	
	action MonitorReliablityAnalysis:AnalysisAction{
		redefines oslcUri = "team3/userexperience/ MonitorReliablityAnalysis";
	}

	/** connects outside analysis to a part  */		
	allocation def AnalysisActionToPart {
		end classAct : AnalysisAction;
		end partDef : Part;
	}
}