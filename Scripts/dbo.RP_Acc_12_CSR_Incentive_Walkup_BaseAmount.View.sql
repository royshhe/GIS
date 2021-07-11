USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_12_CSR_Incentive_Walkup_BaseAmount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
VIEW NAME: RT_Contract_BaseRate_Amount
PURPOSE: Calculate Base Amount for the Contract	
AUTHOR:	Roy He
DATE CREATED: 2005/08/01
USED BY: CSR Incentive Report
MOD HISTORY:
Name 		Date		Comments
				is not defined in the lookup table.
*/

CREATE View [dbo].[RP_Acc_12_CSR_Incentive_Walkup_BaseAmount]
as
SELECT  Contract_Number,  RentalHours, 
--Rate_name, Rate_Level, 
DailyBaseAmount, WeeklyBaeRateAmount, DayPeriod, WeekPeriod,

          /*    

           -- Calculation With Hours
	BaseAmount =
	                
              ( case when 	WeeklyBaeRateAmount<>0 then
	                                 WeeklyBaeRateAmount* CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)
	            when WeeklyBaeRateAmount=0 and DailyBaseAmount<>0 then
	                                   DailyBaseAmount * (CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*7
	                           end
                   )
                        +
		   
                    (
		     case when    
				(
                                                             DailyBaseAmount 
				       *(
					   dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)
		                  	        )> WeeklyBaeRateAmount
                                 		)  
                                                     and   WeeklyBaeRateAmount<>0
					
		        		then WeeklyBaeRateAmount
			 else
				(Case    when DailyBaseAmount<>0 
		                                    then
			                                      DailyBaseAmount 
					           *(
						      		CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))
			                  	             )
						+
                                                                               (	case when (ceiling(RentalHours))>(   
												(CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*24)
                                                                                                                                                   	+((7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*24)
					                                 				 )
							then
                                                                            
		                                                                              (DailyBaseAmount/3+0.01) *(ceiling(RentalHours)-(   
													(CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*24)
		                                                                                                                                                   +((7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*24)
							                                  )
		                                                                               )
							else
							         0
							end
						)	
					else
			                                        WeeklyBaeRateAmount*(dbo.GetRentalDays(RentalHours)/5)
                                 		end
                                 )                                  
			end
		   )
		   ,
		  dbo.GetRentalDays(RentalHours) AS rentaldays,Pick_Up_On, Rate_Name 
*/
	

/*
--Calculation not include extra hours


BaseAmount =
	                    
                  ( case when 	WeeklyBaeRateAmount<>0 and WeekPeriod<>'' then
		                                 WeeklyBaeRateAmount* CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)
		 when WeeklyBaeRateAmount=0 and DailyBaseAmount<>0 then
		                                   DailyBaseAmount * (CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*7
		
		   else 0
	      end
                   )
                        +
		   
                    (
		    
			 -- Do we need this Logic??????
			case when    
				(
                                                             DailyBaseAmount 
				       *(
					 (CONVERT(INT, dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)))
		                  	        )> WeeklyBaeRateAmount
				)	                                 	          
	                                        and   WeeklyBaeRateAmount<>0
					
		        	         	 then 
					WeeklyBaeRateAmount
				 else
				
					(Case    when DailyBaseAmount<>0  and DayPeriod<>''
			                               	 then
			                             	    	DailyBaseAmount 
					            		*(
						      		(CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)))
		                  	          			)
						else
	                                       				 WeeklyBaeRateAmount*(dbo.GetRentalDays(RentalHours)/5)
	                                 		end
	                                 		)                                  
			end
		   ) , 
		  dbo.GetRentalDays(RentalHours) AS rentaldays,Pick_Up_On, Rate_Name , Rate_Level
		--,DailyBaseRateName, WeeklyBaseRateName

*/

-- --Calculation not include extra hours, and Linked with Contract Rate Time Period
BaseAmount =
	                    
                  ( case when 	WeeklyBaeRateAmount<>0 and WeekPeriod<>'' then
		                                 WeeklyBaeRateAmount* CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)
		/* when WeeklyBaeRateAmount=0 and DailyBaseAmount<>0 then
		                                   DailyBaseAmount * (CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))*7
		*/
		   else 0
	      end
                   )
                        +
		   
                    (
		    

		           
		
                                  (Case

			--Both Daily and Weekly (A)

			when DailyBaseAmount<>0  and DayPeriod<>'' and  WeeklyBaeRateAmount<>0 and WeekPeriod<>''
	                       	 then
	                     	    	DailyBaseAmount 
		            		*(
			      		(CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)))
	  	          		)
			
			-- No Time Period exists
			when (DailyBaseAmount<>0  and DayPeriod='') and  (WeeklyBaeRateAmount<>0 and WeekPeriod='')
	                       	 then
			         (case 
					when    
					(
	                                                             DailyBaseAmount 
					       *(
						 (CONVERT(INT, dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)))
			                  	        )> WeeklyBaeRateAmount
					)	                                 	          
		                                        and   WeeklyBaeRateAmount<>0
						
			        	         	 then 
						WeeklyBaeRateAmount
					 else
					
						(Case    when DailyBaseAmount<>0  
				                               	 then
				                             	    	DailyBaseAmount 
						            		*(
							      		(CONVERT(INT,dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)))
			                  	          			)
							else
		                                       				 WeeklyBaeRateAmount*(dbo.GetRentalDays(RentalHours)/5)
		                                 			end
		                                 		)                                  
					 
			         	End )

			
			-- Daily Only (B)
                                        -- B1 No Weekly Period
			when ( DailyBaseAmount<>0  and DayPeriod<>''  and  WeeklyBaeRateAmount<>0 and  WeekPeriod='')
			then
				DailyBaseAmount 
		            		*(
			      		CONVERT(INT,dbo.GetRentalDays(RentalHours))  -- Get Only Day Part, Drop the hours
				)
	  	          	
			--B2 No Weekly Amount
			 when (DailyBaseAmount<>0  and  WeeklyBaeRateAmount=0 )
			 then
				DailyBaseAmount 
		            		*(
			      		CONVERT(INT,dbo.GetRentalDays(RentalHours))  -- Get Only Day Part, Drop the hours
	  	          		)
			
                                       --Weekly Rate Only
                                        -- C1
			when (DailyBaseAmount<>0 and  DayPeriod='') and   (WeeklyBaeRateAmount<>0 and WeekPeriod<>'' )
	                          then  WeeklyBaeRateAmount*ceiling(
									Convert(Int,                                                                                                 -- Drop the Hours
												dbo.GetRentalDays(RentalHours)                        -- Get the Remaining Days
												-7*
												CONVERT(INT,
													      dbo.GetRentalDays(RentalHours)/7  --Get Number of Week
											              )
									)
									/7.0
							    )


                                       when (DailyBaseAmount=0  or  DayPeriod='') and   (WeeklyBaeRateAmount<>0 and WeekPeriod<>'' )
	                          then  WeeklyBaeRateAmount*(
									Convert(Int,							         -- Drop the Hours
												dbo.GetRentalDays(RentalHours)                        -- Get the Remaining Days
												-7*
												CONVERT(INT,
													      dbo.GetRentalDays(RentalHours)/7  --Get Number of Week
											              )
									)
									/7.0
							    )

                                      /*when (DailyBaseAmount=0 )  and  ( WeeklyBaeRateAmount<>0)
	               	then  WeeklyBaeRateAmount*(  (dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))/5 )
                                       */
			
			--C2	
	                     	when (DailyBaseAmount=0) and  ( WeeklyBaeRateAmount<>0 and WeekPeriod='')
	               	then  WeeklyBaeRateAmount* CEILING( 


								CONVERT
								(INT,
									dbo.GetRentalDays(RentalHours)
								)
								/7.0
					)  
							          



  --CONVERT(INT,dbo.GetRentalDays(RentalHours)/7)


			/*when (DailyBaseAmount=0  or  DayPeriod='') and  (WeeklyBaeRateAmount<>0 and WeekPeriod<>'')
	               	then  WeeklyBaeRateAmount*(  (dbo.GetRentalDays(RentalHours)-7*CONVERT(INT,dbo.GetRentalDays(RentalHours)/7))/5 )
			*/

			else 0
         		end
         		)                                  
		
  	    ) , 









		  dbo.GetRentalDays(RentalHours) AS rentaldays,Pick_Up_On, Rate_Name , Rate_Level
		--,DailyBaseRateName, WeeklyBaseRateName



FROM         dbo.RT_Contract_BaseRate_Amount
































GO
