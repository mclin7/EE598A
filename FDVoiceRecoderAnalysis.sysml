 /** Contains definitions for our voice recorders and a simple 
 * example of specifying configurations (record one voice vs record multiple voices)*/
 package FDVoiceRecoderAnalysis {
 	import ScalarValues::*;
	import SI::*;
	import PetFoodDispenser::*;
	
	
    /** For early stage design may not have more than a few levels to distinguish*/
	enum def RecoderUserFriendly :> Integer {
		excellent = 4;
		good = 3;
		okay = 2;
		bad = 1;
	}
	
	part def SingleVoiceRecorder :> VoiceRecorder {
		part redefines buttons[1];
		attribute voicesCacheCount = 1;
	}
	
	part def MultipleVoicesRecorder :> VoiceRecorder {
		part redefines buttons[3];
		attribute voicesCacheCount = 10;
	}
	
	part def singleVioceRecoderFD:> FoodDispenser{
		part redefines voiceRecorder: SingleVoiceRecorder;
	}
	part def multipleVoicesRecorderFD:> FoodDispenser{
		part redefines voiceRecorder: MultipleVoicesRecorder;
	}
	
	analysis def VoiceRecoderAnalysis {
		subject foodDispenser: FoodDispenser;
		
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
				 * 
				 * So evaluate result = evalutate(buttonsNumber) + evaluate(systemComplexity) + evaluate(voicesNumber)
				 */
			}
		}
	}

	package SignalDefinitions{  
        attribute def  PlayEvent;  // push button A, release immediately Or trigger by timer
        attribute def  StartRecordEvent;  // keep putting button A
        attribute def  StopRecordEvent;  // release after long push button A
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
			
			part voicePlayer[1] {
				event occurrence voice_play_event;
			
			}
			message time_to_play_message of PayloadDefinitions::TimerTrigger from scheduler.time_to_feed_event to voiceRecoder.time_to_play_request;
			part scheduler[1] {
				event occurrence time_to_feed_event;
			}
			
	
            message play_message of PayloadDefinitions::PlayVoiceDeliver from voiceRecoder.voice_play_event to voicePlayer.voice_play_event;
		
	}
	}
 }