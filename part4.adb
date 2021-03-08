--lab1 - Cyclic Scheduler
--file: cyclic2.ada
with Ada.Text_IO;
use  Ada.Text_IO;
with Text_Io;
use  Text_Io;
with Ada.Calendar;
use  Ada.Calendar;
with Ada.Numerics.Discrete_Random;

procedure part4  is 
	F1_Start, F1_Curr, F2_Curr, F2_Start, F3_Curr, F3_Start, Before, After, F3_before, F3_after: Time; --might want to change type duration to type time? to reduce delay?
	vTime, vTimeF2 : Duration;
	Finished : Boolean := False;
	F1_bool, F2_bool, F3_bool: Boolean;

	use type Ada.Calendar.Time;
	package DIO is new Text_Io.Fixed_Io(Duration); 
	--Declare F1, which prints out a message when it starts and stops executing   
	procedure F1(Currtime: Duration; StartF1: Time; FinishF1: Time; F1_begin: Boolean) is    
	begin      
		if (F1_begin = True) and FinishF1 - StartF1 = 0.0000 then --if true, start. And portion probably doesn't need to be there
			Put_Line(""); --Add a new line 
			Put_Line("F1 has started executing. The time is now:"); 
			DIO.Put(Currtime);      
		else --if continuing to change time
			Put_Line(""); 
			Put_Line("F1 has finished executing. The time is now:"); 
			DIO.Put(Currtime + duration(FinishF1 - StartF1)); 
				--Needed since time starts at 0 and FinishF1 and StartF1 are not virtual times    
		end if;     
	end F1;
	--Declare F2
	procedure F2(Currtime: Duration; StartF2: Time; FinishF2: Time; F2_begin: Boolean) is    
	begin      
		if (F2_begin = True) then --if true, start
			Put_Line(""); --Add a new line 
			Put_Line("F2 has started executing. The time is now:"); 
			DIO.Put(Currtime);      
		else --if continuing to change time
			Put_Line(""); 
			Put_Line("F2 has finished executing. The time is now:"); 
			DIO.Put(Currtime + duration(FinishF2 - StartF2)); 
				--Needed since time starts at 0 and FinishF2 and StartF2 are not virtual times    
		end if;     
	end F2;
	--Declare F3
	procedure F3(Currtime: Duration; StartF3: Time; FinishF3: Time; F3_begin: Boolean) is    
	begin      
		if (F3_begin = True) then --if true, start
			Put_Line(""); --Add a new line 
			Put_Line("F3 has started executing. The time is now:"); 
			DIO.Put(Currtime);      
		else --if continuing to change time
			Put_Line(""); 
			Put_Line("F3 has finished executing. The time is now:"); 
			DIO.Put(Currtime + duration(FinishF3 - StartF3)); 
			--Needed since time starts at 0 and FinishF3 and StartF3 are not virtual times    
		end if;     
	end F3;
	
begin   
	vTime := 0.0;   
	Before := Ada.Calendar.Clock;
	--Main loop  
	loop 
		Finished := False; --flag for F3 loop
		F1_bool := True; --starting F1 so true
		
		After := Ada.Calendar.Clock;  
		--Execute F1 every 1 second   
		if After - Before >= 1.000000000 then 
			vTime := vTime + (After - Before); --Needed since time starts at 0 
			
			---------------------------------------------------------------F1 starts
			F1_Start := Ada.Calendar.Clock; --Get start time of F1 
			F1(Currtime => vTime, StartF1 => Before, FinishF1 => Before, F1_begin => F1_bool); --Initialize F1 
			loop --F1 starts
				F1_Curr := Ada.Calendar.Clock; --Get current time
				exit when  F1_Curr - F1_Start >= 0.300000; --Assuming F1 takes 0.3 seconds
			end loop;
			F1_bool := False; --not starting so false
			F1(Currtime => vTime, StartF1 => F1_Start, FinishF1 => F1_Curr, F1_begin => F1_bool); --F1 ends
			vTimeF2 := vTime + duration(F1_Curr - F1_Start);--current time for F2
			---------------------------------------------------------------F1 ends
			
			---------------------------------------------F3 starts
			F3_before := Ada.Calendar.Clock; 
			F3_loop:
				loop --loop until 0.5s after F1 starts
					F3_after := Ada.Calendar.Clock;
					if (F3_after - F3_before >= 0.200000) then --Execute every 0.5s (so 0.2s because of F1's 0.3 time) after F1 starts
						F3_Start := Ada.Calendar.Clock; --Get start time of F3
						F3_bool := True;--true so output can start
						F3(Currtime => vTime + 0.5, StartF3 => Before, FinishF3 => Before, F3_begin => F3_bool); --Initialize F3
						loop --F3 starts
							--Get current time
							F3_Curr := Ada.Calendar.Clock;   
							exit when F3_Curr - F3_Start >= 0.20000000; --execution time of 0.2s
						end loop;
						F3_bool := False; --not the start anymore, so false
						F3(Currtime => vTime + 0.5, StartF3 => F3_Start, FinishF3 => F3_Curr, F3_begin => F3_bool); --output F3
						Finished := True;
					end if;
					exit F3_loop when Finished; --stop F3 when output is made
			end loop F3_loop;
			---------------------------------------------F3 ends

			---------------------------------------------F2 starts
			F2_Start := Ada.Calendar.Clock; --Get start time of F2
			F2_bool := True;
			F2(Currtime => (vTimeF2), StartF2 => Before, FinishF2 => Before, F2_begin => F2_bool); --Initialize F2
			loop
				--Get current time    
				F2_Curr := Ada.Calendar.Clock;  
				exit when  F2_Curr - F2_Start >= 0.150000000; --Assuming F2 takes 0.15 seconds 
			end loop; 
			F2_bool := False;
			--After F2 finishes executing, call the F2 procedure again to obtain the finish time 
			F2(Currtime => vTimeF2, StartF2 => F2_Start, FinishF2 => F2_Curr, F2_begin => F2_bool); 
			---------------------------------------------F2 ends

		Before := After;  --next start time for 1 second loop    
		end if; --Every 1 second  
	end loop; --Main loop  
end part4; 