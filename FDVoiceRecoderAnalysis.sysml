 /** Contains definitions for our voice recorders and a simple 
 * example of specifying configurations (record one voice vs record multiple voices)*/
 package FDVoiceRecorderAnalysis {
 	import ScalarValues::*;
	import SI::*;
	import PetFoodDispenser::*;
	import PetFoodDispenserAnalyses::*;
	import FDFriendlyVerfication::*;
	

	
	part def SingleVoiceRecorder :> VoiceRecorder {
		part redefines buttons[1];
		attribute voicesCacheCount = 1;
		attribute friendlyIndex = EvaluateIndex::good;
		attribute costIndex = EvaluateIndex::excellent;
	}
	
	part def MultipleVoicesRecorder :> VoiceRecorder {
		part redefines buttons[3];
		attribute voicesCacheCount = 4;
		attribute friendlyIndex = EvaluateIndex::good;
		attribute costIndex = EvaluateIndex::bad;
	}
	
		
	part def TestMonitor :> Monitor ;
	
	part singleVioceRecoderFD: FoodDispenser{
		part redefines voiceRecorder: SingleVoiceRecorder;
	}
	
	part multipleVoicesRecorderFD: FoodDispenser{
		part redefines voiceRecorder: MultipleVoicesRecorder;
	}
	
	part singleVoiceRecorder:SingleVoiceRecorder;
	part multipleVoicesRecorder:MultipleVoicesRecorder;
	part testMonitor: TestMonitor;
	/* indicating where we got our sensor analysis from */

	allocation monitorcostAnalysis : AnalysisActionToPart
		allocate MonitorcostAnalysis  to testMonitor.cost;
	
	allocation monitorReliablityAnalysis : AnalysisActionToPart
		allocate MonitorReliablityAnalysis to testMonitor.performance;

    calc def RecorderEvaluation {
        in friendlyIndex: Integer;
        in costIndex: Integer;
        return :Integer;
    }
    
	analysis voiceRecorderTradeOffAnalysis {
		subject foodDispensers[2]: FoodDispenser;

		part fDWithSigleRecorder:>foodDispensers{
			part redefines voiceRecorder: SingleVoiceRecorder;
		}
		part fDWithMultipleRecorder:>foodDispensers{
			part redefines voiceRecorder: MultipleVoicesRecorder;
		}

		/* indicating where we got our sensor analysis from */
		allocation singleVioceRecorderFDAnalysis : AnalysisActionToPart
		allocate voiceRecorderFriendlyAnalysis to fDWithSigleRecorder.voiceRecorder.friendlyIndex;

		allocation sigleVoiceRecorderSystemComplexityAnalysis: AnalysisActionToPart
	    allocate voiceRecorderSystemComplexityAnalysis to fDWithSigleRecorder.voiceRecorder.costIndex;
	
		allocation multiVoiceRecorderSystemComplexityAnalysis : AnalysisActionToPart
		allocate voiceRecorderSystemComplexityAnalysis to fDWithMultipleRecorder.voiceRecorder.costIndex;
		
		allocation multipleVioceRecorderFDAnalysis : AnalysisActionToPart
		allocate voiceRecorderFriendlyAnalysis to fDWithMultipleRecorder.voiceRecorder.friendlyIndex;
	
		attribute singleVoiceRecorderIndex = RecorderEvaluation(fDWithSigleRecorder.voiceRecorder.friendlyIndex, 
																fDWithSigleRecorder.voiceRecorder.costIndex);
		attribute multipleVoicesRecorderIndex = RecorderEvaluation(fDWithMultipleRecorder.voiceRecorder.friendlyIndex,
																 fDWithMultipleRecorder.voiceRecorder.costIndex);
		
		/** note that here we are simply returning the choice we come up with */
		return isSingleVioceBetter : Boolean = singleVoiceRecorderIndex>multipleVoicesRecorderIndex;

		objective SingleOrMultipleVoicesAnalysisObjective {
			doc /* determine whether to support recording single voice or multiple voices
			 * for the FoodDispenser recoder
			 */

			require userFriendlySpecification::recorderEasyToUseReq;
			require userFriendlySpecification::recorderOneMoreVoicesReq;
			require userFriendlySpecification::recorderAffortableReq;

			assume constraint {
				doc /* 
				 * Evaluate the system based on:
				 * 1. The complexity of system, more complexity more cost and time to build the system. Will use the state machine Diagram to support the satement
				 * 2. The number of voices can be recorded, More voices mean more cache(cost) but better user experience
				 * return true if singleVoiceRecorder(costIndex + friendlyIndex) > multipleVoiceRecorder(costIndex + friendlyIndex) Or multipleVoiceRecorder.costIndex == EvaluateIndex::bad;
				 */
			}
		
		}
	}

	package SignalDefinitions{  
        attribute def  PlayEvent;  // push button A, release immediately Or trigger by timer
        attribute def  StartRecordEvent;  // long push(press and hold button for 3s)
        attribute def  StopRecordEvent;  // release after long push(press and hold button for 3s) button A
        attribute def  DeleteEvent;    // push button C
        attribute def  NextVoiceEvent;  // push button B
        attribute def  FinishPlayEvent;  
        attribute def  DeleteDoneEvent;  
        attribute def  VoicesIsFullEvent;
	}
	
	package VoiceRecorderStateMachines {
		state def VoiceRecorderState;
		state def VoiceRecorderAction;
		
		state def SigleVoiceRecord {
			entry action init;
			exit action finalize;

			state playState: VoiceRecorderState;
			state recordingState : VoiceRecorderState;
			state pendingState: VoiceRecorderState;

			
			transition initial
				first init
				then pendingState;
				
		    transition pendingState_to_recordingState
		        first pendingState
				accept SignalDefinitions::StartRecordEvent
				do action recordVoice
				then recordingState;
		
			transition recordingState_to_pendingState
			    first recordingState
			    accept SignalDefinitions::StopRecordEvent
			    do action stopRecord
			    then pendingState;
			
			transition pendingState_to_playState
			    first pendingState
			    accept SignalDefinitions::PlayEvent
			    do action playVoice
			    then playState;
			
			transition playState_to_pendingState
			    first playState
			    accept SignalDefinitions::FinishPlayEvent
			    do action stopPlay
			    then pendingState;
        
		}
		
		state def MultipleVoicesRecoder {
			entry action init;
			exit action finalize;

			state deleteState: VoiceRecorderState;
			state alarmState: VoiceRecorderState;
			state selectState: VoiceRecorderState;

			state playState: VoiceRecorderState;
			state recordingState : VoiceRecorderState;
			state pendingState: VoiceRecorderState;


		    transition pendingState_to_recordingState
		        first pendingState
				accept SignalDefinitions::StartRecordEvent
				do action checkVoiceIsFull_No_Then_recordVoice
				then recordingState;
		
			transition recordingState_to_pendingState
			    first recordingState
			    accept SignalDefinitions::StopRecordEvent
			    do action stopRecord
			    then pendingState;
			
			transition pendingState_to_playState
			    first pendingState
			    accept SignalDefinitions::PlayEvent
			    do action playVoice
			    then playState;
			
			transition playState_to_pendingState
			    first playState
			    accept SignalDefinitions::FinishPlayEvent
			    do action stopPlay
			    then pendingState;
			   
            transition pendingState_to_NextState
                first pendingState
                accept SignalDefinitions::NextVoiceEvent
                do action selectNextVoice
                then selectState;
            
            transition selectState_to_deleteState
                first selectState
                accept SignalDefinitions::DeleteEvent
                do action deleteSelectedVoice
                then deleteState;
                
            transition deleteState_to_pendingState
                first deleteState
                accept SignalDefinitions::DeleteDoneEvent
                then pendingState;
                
            transition pendingState_to_alarmState
                first pendingState
                accept SignalDefinitions::StartRecordEvent
                do action checkVoicesFull_Yes
                then alarmState;
                
            transition alarmState_to_pendingState
                first alarmState
                do action alarm
                then pendingState;
            
		}
		
	}
	
	package RecodVoiceSequenceModel {
		package PayloadDefinitions {
			item def RecordedVoiceDeliver;
			item def TimerTrigger;
			item def PlayVoiceDeliver;
	
	    }
		occurrence def RecodVoiceSequence {  //  TODO ADD LOOP?
			part petOwner[1] {
				event  occurrence record_voice_request;
			}
			
		     part voiceRecorder[1]{
				event occurrence record_request_received;
				
				event occurrence time_to_play_request;
				then event occurrence voice_play_event;
			}
			message record_voice_message of PayloadDefinitions::RecordedVoiceDeliver from petOwner.record_voice_request to voiceRecorder.record_request_received;
			
			part mike[1] {
				event occurrence voice_play_event;
			
			}
			message time_to_play_message of PayloadDefinitions::TimerTrigger from scheduler.time_to_feed_event to voiceRecorder.time_to_play_request;
			part scheduler[1] {
				event occurrence time_to_feed_event;
			}
			
	
            message play_message of PayloadDefinitions::PlayVoiceDeliver from voiceRecorder.voice_play_event to mike.voice_play_event;
		
	}
	}
 }