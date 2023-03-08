 /** Contains definitions for our voice recorders and a simple 
 * example of specifying configurations (record one voice vs record multiple voices)*/
 package FDVoiceRecoderAnalysis {
 	import ScalarValues::*;
	import SI::*;
	import PetFoodDispenser::*;
	import PetFoodDispenserAnalyses::*;
	
	
    /** For early stage design may not have more than a few levels to distinguish*/
	enum def RecoderIndex :> Integer {
		excellent = 4;
		good = 3;
		okay = 2;
		bad = 1;
	}
	
	part def SingleVoiceRecorder :> VoiceRecorder {
		part redefines buttons[1];
		attribute voicesCacheCount = 1;
		attribute friendlyIndex = RecoderIndex::good;
		attribute costIndex = RecoderIndex::excellent;
	}
	
	part def MultipleVoicesRecorder :> VoiceRecorder {
		part redefines buttons[3];
		attribute voicesCacheCount = 10;
		attribute friendlyIndex = RecoderIndex::okay;
		attribute costIndex = RecoderIndex::bad;
	}
	
	part singleVioceRecoderFD:> FoodDispenser{
		part redefines voiceRecorder: SingleVoiceRecorder;
	}
	
	part multipleVoicesRecorderFD:> FoodDispenser{
		part redefines voiceRecorder: MultipleVoicesRecorder;
	}
	
	part singleVoiceRecorder:SingleVoiceRecorder;
	part multipleVoicesRecorder:MultipleVoicesRecorder;
	/* indicating where we got our sensor analysis from */
	allocation singleVioceRecoderFDAnalysis : AnalysisActionToPart
		allocate voiceRecoderFriendlyAnalysis to singleVoiceRecorder.friendlyIndex;
	
	allocation multipleVioceRecoderFDAnalysis : AnalysisActionToPart
		allocate voiceRecoderFriendlyAnalysis to multipleVoicesRecorder.friendlyIndex;
	
	allocation sigleVoiceRecoderSystemComplexityAnalysis: AnalysisActionToPart
	    allocate voiceRecoderSystemComplexityAnalysis to singleVoiceRecorder.costIndex;
	    
    allocation multiVoiceRecoderSystemComplexityAnalysis : AnalysisActionToPart
		allocate voiceRecoderSystemComplexityAnalysis to multipleVoicesRecorder.costIndex;
		
    calc def RecoderEvaluation {
        in friendlyIndex: Integer;
        in costIndex: Integer;
        return eval:Integer;
    }
    
	analysis def voiceRecoderTradeOffAnalysis {
		subject foodDispenser: FoodDispenser;
		/** note that here we are simply returning the choice we come up with */
		return isSingleVioceBetter : Boolean;
		
		objective SingleOrMultipleVoicesAnalysisObjective {
			doc /* determine whether to support recording single voice or multiple voices
			 * for the FoodDispenser recoder
			 */
			assume constraint {
				doc /* 
				 * Evaluate the system based on:
				 * 1. The number of buttons, more button more operational complexity
				 * 2. The complexity of system, more complexity more cost and time to build the system. Will use the state machine Diagram to support the satement
				 * 3. The number of voices can be recorded, More voices mean more cache(cost) but better user experience
				 * return true if singleVoiceRecoder(costIndex + friendlyIndex) > multipleVoiceRecoder(costIndex + friendlyIndex) Or multipleVoiceRecoder.costIndex == RecoderIndex::bad;
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
			
		     part voiceRecoder[1]{
				event occurrence record_request_received;
				
				event occurrence time_to_play_request;
				then event occurrence voice_play_event;
			}
			message record_voice_message of PayloadDefinitions::RecordedVoiceDeliver from petOwner.record_voice_request to voiceRecoder.record_request_received;
			
			part mike[1] {
				event occurrence voice_play_event;
			
			}
			message time_to_play_message of PayloadDefinitions::TimerTrigger from scheduler.time_to_feed_event to voiceRecoder.time_to_play_request;
			part scheduler[1] {
				event occurrence time_to_feed_event;
			}
			
	
            message play_message of PayloadDefinitions::PlayVoiceDeliver from voiceRecoder.voice_play_event to mike.voice_play_event;
		
	}
	}
 }