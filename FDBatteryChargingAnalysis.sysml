package FDBatteryChargingAnalysis {
 	import ScalarValues::*;
	import SI::*;
	import PetFoodDispenser::*;
	import PetFoodDispenserAnalyses::*;
	import FDFriendlyVerfication::*;

    calc def BatteryEvaluation {
		in friendlyIndex : Integer;
		in costIndex : Integer;
		in complexity : Integer;
		return : Integer;
	}

	part def BatteryChargingSystem :> ChargingSystem {
		attribute redefines hasBattery = true;
		attribute friendlyIndex = EvaluateIndex::excellent;
		attribute costIndex = EvaluateIndex::okay;
		attribute complexity = EvaluateIndex::bad;
	}
	
	part def SingleChargingSystem :> ChargingSystem {
		attribute redefines hasBattery = false;
		attribute friendlyIndex = EvaluateIndex::okay;
		attribute costIndex = EvaluateIndex::good;
		attribute complexity = EvaluateIndex::okay;
	}

	part singleChargingSystemFD: FoodDispenser{
		part redefines charginsystem : SingleChargingSystem;
	}

	part batteryChargingSystemFD: FoodDispenser{
		part redefines charginsystem : BatteryChargingSystem;
	}

	part singleChargingSystem:SingleChargingSystem;
	part batteryChargingSystem:BatteryChargingSystem;

	/* indicating where we got our charging analysis from */

	allocation singleChargingFDAnalysis : AnalysisActionToPart
		allocate batteryChargingFriendlyAnalysis to singleChargingSystem.friendlyIndex;

	allocation batteryChargingFDAnalysis : AnalysisActionToPart
		allocate batteryChargingFriendlyAnalysis to batteryChargingSystem.friendlyIndex;

	allocation singleChargingComplexityAnalysis : AnalysisActionToPart
		allocate batteryChargingComplexityAnalysis to singleChargingSystem.complexity;

	allocation batteryChargingComplexityAnalysis : AnalysisActionToPart
		allocate batteryChargingComplexityAnalysis to batteryChargingSystem.complexity;
	
	allocation singleChargingCostAnalysis : AnalysisActionToPart
		allocate batteryChargingCostAnalysis to singleChargingSystem.cost;

	allocation batteryChargingCostAnalysis : AnalysisActionToPart
		allocate batteryChargingCostAnalysis to batteryChargingSystem.cost;
	
	/* Trade-off between battery / no-battery charging choice */
	analysis batteryChargingTradeOffAnalysis {
		subject foodDispenser[2]: FoodDispenser;

		part fdWithBatteryCharging :> foodDispenser{
			part redefines charginsystem: BatteryChargingSystem;
		}

		part fdWithoutBatteryCharging :> foodDispenser{
			part redefines charginsystem: SingleChargingSystem;
		}
		
		attribute batteryChargingIndex = BatteryEvaluation(
			fdWithBatteryCharging.charginsystem.friendlyIndex, 
			fdWithBatteryCharging.charginsystem.costIndex,
			fdWithBatteryCharging.charginsystem.complexity);

		attribute singleChargingIndex = BatteryEvaluation(
			fdWithoutBatteryCharging.charginsystem.friendlyIndex, 
			fdWithoutBatteryCharging.charginsystem.costIndex,
			fdWithoutBatteryCharging.charginsystem.complexity);
		
		return isSingleChargingBetter : Boolean = singleChargingIndex>batteryChargingIndex;

		objective SingleOrBatteryChargingAnalysisObjective {
			doc
			/* determine whether should we support single charging system 
			or battery charging system */

			require userFriendlySpecification::powerStandardRequirement;

			assume constraint {
				doc /* 
				 * Evaluate the system based on:
				 * 1. The complexity of charging system, more complexity more cost and time to build the system. Will use the state machine Diagram to support the satement
				 * 2. How much users' need toward having a battery charging to gaining a longer using time
				 * 3. Cost of adding build battery charging system in current model; and how much profit can we made out of it
				 */
			}
		}
		
	}
	
}