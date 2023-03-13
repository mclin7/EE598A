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
	
	/** connects outside analysis to a part  */		
	allocation def AnalysisActionToPart {
		end classAct : AnalysisAction;
		end partDef : Part;
	}
}