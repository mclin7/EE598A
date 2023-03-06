package PetFoodDispenserAnalyses{
	import AnalysisActions::*;
	import Parts::*;

	/** see in teamP Analysis List  */
	action voiceRecoderAnalysis : AnalysisAction {
		redefines oslcUri = "team3/analysis/voiceRecoderAnalysis";
	}
	
	action bowlMaterialHealthyAnalysis: AnalysisAction{
		redefines oslcUri = "team3/analysis/bowlMaterialHealthyAnalysis";
	}
	
	/** connects outside analysis to a part  */		
	allocation def AnalysisActionToPart {
		end classAct : AnalysisAction;
		end partDef : Part;
	}
}