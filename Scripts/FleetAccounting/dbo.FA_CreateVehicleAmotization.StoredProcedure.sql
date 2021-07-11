USE [GISData]
GO

/*
PROCEDURE NAME: FA_CreateVehicleAmotization
PURPOSE: Create Vehicle Depreciation Amotization

AUTHOR: Roy He
DATE CREATED: 2019/04/20
USED BY: Fleet Accounting
MOD HISTORY:
Name 		Date		Comments
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[FA_CreateVehicleAmotization]  --'2016-12-01', 'C'

	@AMOMonth VarChar(24),
	@Mode CHAR(1)='C'
As
--delete FA_Vehicle_Amortization where [AMO_Month]='2010-08-01'

--Vehicle  AMO Case					
--			Starting	Ending	
--1		MB	AB	AE	ME
--2		MB	AB	ME	AE
--3		AB	MB	AE	ME
--4		AB	MB	ME	AE
 
DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime
Declare @i int 


SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1

  -- Remove Beginning Balance entry when  regenerating for new unit---
if @Mode='C' 
	Begin
		Delete FA_Vehicle_Amortization where InService_Months=0 and AMO_Month  =DATEADD(month,-1, @dMonthBeginning)
		Delete FA_Vehicle_Amortization where AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd
   End
else
	Begin
		  Select @i=count(*) from FA_Vehicle_Amortization where AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd
          -- Only When the AMO has not been generated we will remove the initial balance for the preview
		  if @i=0 
			  Delete FA_Vehicle_Amortization where InService_Months=0 and AMO_Month  =DATEADD(month,-1, @dMonthBeginning)
    End



-- In Order to Get History Data, we have to keep the Balance Column for the Book Value

Insert  into FA_Vehicle_Amortization
SELECT 
			V.Unit_Number,     
			 (DepHist.Depreciation_Start_Date-Day(DepHist.Depreciation_Start_Date))-Day(DepHist.Depreciation_Start_Date-Day(DepHist.Depreciation_Start_Date))+1 as AMO_Month,  			  
			 NULL As AMO_Amount,  
			 NULL As Dep_Credit,
			 0 as InService_Months,	
  			 V.Vehicle_Cost as Balance,   			 
			  getdate() AS Last_Updated_On
--select *
FROM        (
  -- Only Get the first one when there is more than one hist record
  Select DH.* FROM  dbo.FA_Vehicle_Depreciation_History DH	Inner Join 
	( Select Unit_Number, Min(Depreciation_Start_Date) Depreciation_Start_Date  FROM  dbo.FA_Vehicle_Depreciation_History
	 Group By Unit_Number) FirstDH
	 On	 DH.Unit_Number= FirstDH.Unit_Number and   DH.Depreciation_Start_Date= FirstDH.Depreciation_Start_Date
 )

DepHist  


INNER JOIN
                      dbo.Vehicle V ON DepHist.Unit_Number = V.Unit_Number
WHERE     (DepHist.Unit_Number NOT IN
                          (SELECT     Unit_Number
                            FROM          FA_Vehicle_Amortization)) and V.Vehicle_Cost is not null 
		and DepHist.Depreciation_Start_Date BETWEEN @dMonthBeginning AND @dMonthEnd

  

CREATE TABLE #FA_Vehicle_Amortization (
	[Unit_Number] [int] NOT NULL ,
	[AMO_Month] [datetime] NOT NULL ,
	[AMO_Amount] [decimal](9, 2) NULL ,
	[Dep_Credit] [decimal](9, 2) NULL ,
	[InService_Months] [int] NULL ,
	[Balance] [decimal](10, 2) NULL ,
	[Last_Updated_On] [datetime] NULL 
)  
 
--Delete #FA_Vehicle_Amortization
--Insert 


/*
Delete FA_Vehicle_Amortization where AMO_Month=@dMonthBeginning
Insert into FA_Vehicle_Amortization
*/
INSERT INTO  #FA_Vehicle_Amortization
Select           VehicleAMO.Unit_Number,  
					VehicleAMO.MB, 
					(Case When VehicleAMO.PreMonthBalance-SUM(VehicleAMO.AMOAmount)>=0 Then SUM(VehicleAMO.AMOAmount)
							 Else VehicleAMO.PreMonthBalance
					End)
					as TotalAMOAmount, 
					
					 
					 
					 -- To Advoid Duplicate when there are two dep period within a month
					 -- SUM(VehicleAMO.DepCredit)	 as DepCredit,
					(Case   
								When
								(
									SELECT     SUM(Dep_Credit) AS PrevTotalDepCredit
									FROM         dbo.FA_Vehicle_Amortization
									Where Unit_number=VehicleAMO.Unit_Number   
									And AMO_Month<>@dMonthBeginning -- Exclude Current Month
									GROUP BY Unit_Number
								)+ SUM(VehicleAMO.DepCredit)>=VehicleAMO.Volume_Incentive 
								--- We need to add something here hahahaxxxxxxxxxxxxxxxxxxx
								
									
							    Then Volume_Incentive-(Select SUM(Dep_Credit) AS PrevTotalDepCredit
															FROM         dbo.FA_Vehicle_Amortization
															Where Unit_number=VehicleAMO.Unit_Number   
															And AMO_Month<>@dMonthBeginning -- Exclude Current Month
															GROUP BY Unit_Number
															)
								Else 	 SUM(VehicleAMO.DepCredit)
						End)		 as DepCredit,
					             
		             VehicleAMO.InserviceMonths, 
					--VehicleAMO.Balance,
                   	(Case When VehicleAMO.PreMonthBalance-SUM(VehicleAMO.AMOAmount)>=0 Then
							 VehicleAMO.PreMonthBalance-SUM(VehicleAMO.AMOAmount)
							Else
							0
					End) AS Balance,
					GetDate() as LastUpdatedOn			

From
(
			Select   VehicleDep.Unit_Number,  
						VehicleDep.MB, 
						VehicleDep.Volume_Incentive,
						VehicleDep.PreMonthBalance,
						SUM(VehicleDep.AMOAmount) AMOAmount,	
						(Case   
                                 When 
								(
									SELECT     SUM(Dep_Credit) AS PrevTotalDepCredit
									FROM         dbo.FA_Vehicle_Amortization
									Where Unit_number=VehicleDep.Unit_Number  And AMO_Month<>@dMonthBeginning  -- Exclude Current Month
									GROUP BY Unit_Number
								)>=Volume_Incentive Then 0.00
								When
								(
									SELECT     SUM(Dep_Credit) AS PrevTotalDepCredit
									FROM         dbo.FA_Vehicle_Amortization
									Where Unit_number=VehicleDep.Unit_Number   
									And AMO_Month<>@dMonthBeginning -- Exclude Current Month
									GROUP BY Unit_Number
								)+DepCredit>=Volume_Incentive 
								Or (Sold_Date is Not Null and Sold_Date<=ME)
								--	Or 
								--(
								--		(VehicleDep.DE-1<=ME) 
								--		And 
								--		(
								--			SELECT     SUM(Dep_Credit) AS PrevTotalDepCredit
								--			FROM         dbo.FA_Vehicle_Amortization
								--			Where Unit_number=VehicleDep.Unit_Number  
								--			GROUP BY Unit_Number
								--		)<Volume_Incentive
								-- )
									
							    Then Volume_Incentive-(Select SUM(Dep_Credit) AS PrevTotalDepCredit
															FROM         dbo.FA_Vehicle_Amortization
															Where Unit_number=VehicleDep.Unit_Number   
															And AMO_Month<>@dMonthBeginning -- Exclude Current Month
															GROUP BY Unit_Number
															)
								Else 	DepCredit
						End)		 as DepCredit,
						             
			            
						Datediff(  month, 
										(SELECT  Top 1  Depreciation_Start_Date  FROM         dbo.FA_Vehicle_Depreciation_History	
																		Where Unit_number=VehicleDep.Unit_Number  
																		Order by Depreciation_Start_Date  
										 ) 
										,@dMonthBeginning 
									)+1 As  InserviceMonths 
								
			From
			(

			-- Case 1
			--1		MB	AB	AE	ME		
					Select distinct  
					Unit_Number, 
					DB Valid_From,
					DE-1 Valid_To,
					Datediff(Day,  DB,  DE-1) +1 as AMODays,
					MonthlyAMO,					
					Round((MonthlyAMO*12/365)*(Datediff(Day,  DB,  DE-1) +1),2) AMOAmount,	
												
					(Case 
						When MonthlyAMO<>0 then	
							Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  DB,  DE-1) +1),2) 
						Else
							0
					End) DepCredit, 
					
					Volume_Incentive,
					PreMonthBalance,
					@dMonthBeginning MB, 
					@dMonthEnd ME,
					DB,
					DE,
					Sold_Date
				
					From 
						(
							SELECT      DH.Unit_Number, 
											Datediff(month, DH.Depreciation_Start_Date,@dMonthBeginning )+1 as LoanMonth,
											(Case WHEN DH.Depreciation_Rate_Amount  Is Null  AND (DH.Depreciation_Rate_Percentage is Not Null AND DH.Depreciation_Rate_Percentage<>0) THEN Vehicle_Cost*DH.Depreciation_Rate_Percentage/100
													  WHEN DH.Depreciation_Rate_Amount  Is Not Null   THEN DH.Depreciation_Rate_Amount
													  ELSE 0
											End) MonthlyAMO,		    
					    
											DH.Depreciation_Start_Date DB, 
											(Case When DH.Depreciation_End_Date Is not Null Then DH.Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End) DE, 
											DH.Depreciation_Rate_Amount RateAmount, 
											DH.Depreciation_Rate_Percentage RatePercentage, 
											V.Vehicle_Cost VCost,
											V.Volume_Incentive,
											V.Planned_Days_In_Service,
											V.Sold_Date,											
											(SELECT  PrevMonthAMO.PreBalance  from
												   (
													--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
													SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
													Where Unit_number=DH.Unit_Number  And AMO_Month<@dMonthBeginning
													Order by AMO_Month DESC
													
													) PrevMonthAMO
											) As PreMonthBalance
									
									
						FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
											  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
									
						Where ( DH.Depreciation_End_Date-1>=@dMonthBeginning or   DH.Depreciation_End_Date is null) 
					) AMOBook
					Where DB>=@dMonthBeginning and DE-1<=@dMonthEnd
					--And AMOBook.Unit_Number=164335


					-- Case 2
					Union

					Select distinct  
					Unit_Number, 
					DB Valid_From,
					@dMonthEnd Valid_To,
					Datediff(Day,  DB,  @dMonthEnd) +1 as AMODays,
					MonthlyAMO,
					Round((MonthlyAMO*12/365)*(Datediff(Day,  DB,  @dMonthEnd) +1),2) AMOAmount,
					(Case 
						When MonthlyAMO<>0 then	
						Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  DB,  @dMonthEnd) +1),2) 
					Else
						0
					End) DepCredit, 
					Volume_Incentive,		
					PreMonthBalance,
					@dMonthBeginning MB, 
					@dMonthEnd ME,
					DB,
					DE,
					Sold_Date
				
					From 
						(
							SELECT      DH.Unit_Number, 
											Datediff(month, DH.Depreciation_Start_Date,@dMonthBeginning )+1 as LoanMonth,
											(Case WHEN DH.Depreciation_Rate_Amount  Is Null  AND (DH.Depreciation_Rate_Percentage is Not Null AND DH.Depreciation_Rate_Percentage<>0) then Vehicle_Cost*DH.Depreciation_Rate_Percentage/100
													  WHEN DH.Depreciation_Rate_Amount  Is Not Null  THEN  DH.Depreciation_Rate_Amount
													  ELSE 0
											End) MonthlyAMO,
					    
											DH.Depreciation_Start_Date DB, 
											(Case When DH.Depreciation_End_Date Is not Null Then DH.Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End) DE, 
											DH.Depreciation_Rate_Amount RateAmount, 
											DH.Depreciation_Rate_Percentage RatePercentage, 
											V.Vehicle_Cost VCost,
											V.Volume_Incentive,
											V.Planned_Days_In_Service,
											V.Sold_Date,

											(SELECT  PrevMonthAMO.PreBalance  from
												   (
													--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
													SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
													Where Unit_number=DH.Unit_Number  And AMO_Month<@dMonthBeginning
													Order by AMO_Month DESC
													
													) PrevMonthAMO
											) As PreMonthBalance
									
									
						FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
											  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
									
						Where ( DH.Depreciation_End_Date-1>=@dMonthBeginning or   DH.Depreciation_End_Date is null) 
					) AMOBook
					Where DB>=@dMonthBeginning  And DB<=@dMonthEnd and @dMonthEnd<=DE-1
					--And AMOBook.Unit_Number=164335

					--3
					Union

					Select distinct  
					Unit_Number, 
					@dMonthBeginning Valid_From,
					DE-1 Valid_To,
					Datediff(Day,  @dMonthBeginning,  DE-1) +1 as AMODays,
					MonthlyAMO,
					Round((MonthlyAMO*12/365)*(Datediff(Day,  @dMonthBeginning,  DE-1) +1),2) AMOAmount,
					(Case 
						When MonthlyAMO<>0 then		
							Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  @dMonthBeginning,  DE-1) +1 ),2) 
						Else
							0
					End) DepCredit, 
					
					Volume_Incentive,
					PreMonthBalance,
					@dMonthBeginning MB, 
					@dMonthEnd ME,
					DB,
					DE,
					Sold_Date
					--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dMonthBeginning,  DE-1) +1),2) as Balanace, 
					--GetDate()

					From 
						(
							SELECT      DH.Unit_Number, 
											Datediff(month, DH.Depreciation_Start_Date,@dMonthBeginning )+1 as LoanMonth,
						
											(Case WHEN DH.Depreciation_Rate_Amount  Is Null  AND (DH.Depreciation_Rate_Percentage is Not Null AND DH.Depreciation_Rate_Percentage<>0) then Vehicle_Cost*DH.Depreciation_Rate_Percentage/100
													  WHEN DH.Depreciation_Rate_Amount  Is Not Null  THEN  DH.Depreciation_Rate_Amount
													  ELSE 0
											End) MonthlyAMO,
					    
											DH.Depreciation_Start_Date DB, 
											(Case When DH.Depreciation_End_Date Is not Null Then DH.Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End) DE, 
											DH.Depreciation_Rate_Amount RateAmount, 
											DH.Depreciation_Rate_Percentage RatePercentage, 
											V.Vehicle_Cost VCost,
											V.Volume_Incentive,
											V.Planned_Days_In_Service,
											V.Sold_Date,

											(SELECT  PrevMonthAMO.PreBalance  from
												   (
													--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
													SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
													Where Unit_number=DH.Unit_Number  And AMO_Month<@dMonthBeginning
													Order by AMO_Month DESC
													
													) PrevMonthAMO
											) As PreMonthBalance
									
									
						FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
											  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
									
						Where ( DH.Depreciation_End_Date-1>=@dMonthBeginning or   DH.Depreciation_End_Date is null) 
					) AMOBook
					Where @dMonthBeginning>=DB and @dMonthBeginning<=DE-1 And DE-1<=@dMonthEnd
					--And AMOBook.Unit_Number=164335

					--4
					Union

					Select distinct  
					Unit_Number, 
					@dMonthBeginning Valid_From,
					@dMonthEnd Valid_To,
					Datediff(Day,  @dMonthBeginning,  @dMonthEnd) +1 as AMODays,
					MonthlyAMO,
					Round((MonthlyAMO*12/365)*(Datediff(Day,  @dMonthBeginning,  @dMonthEnd) +1),2) AMOAmount,		
					(Case 
					When MonthlyAMO<>0 then
						Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  @dMonthBeginning,  @dMonthEnd) +1),2) 
					Else
						0
					End) DepCredit, 
					Volume_Incentive,
					PreMonthBalance,
					@dMonthBeginning MB, 
					@dMonthEnd ME,
					DB,
					DE,
					Sold_Date
					--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dMonthBeginning,  @dMonthEnd) +1),2) as Balanace, 
					--GetDate()

					From 
						(
							SELECT      DH.Unit_Number, 
											Datediff(month, DH.Depreciation_Start_Date,@dMonthBeginning )+1 as LoanMonth,
											(Case WHEN DH.Depreciation_Rate_Amount  Is Null  AND (DH.Depreciation_Rate_Percentage is Not Null AND DH.Depreciation_Rate_Percentage<>0) then Vehicle_Cost*DH.Depreciation_Rate_Percentage/100
													  WHEN DH.Depreciation_Rate_Amount  Is Not Null  THEN  DH.Depreciation_Rate_Amount
													  ELSE 0
											End) MonthlyAMO,
					    
											DH.Depreciation_Start_Date DB, 
											(Case When DH.Depreciation_End_Date Is not Null Then DH.Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End) DE, 
											DH.Depreciation_Rate_Amount RateAmount, 
											DH.Depreciation_Rate_Percentage RatePercentage, 
											V.Vehicle_Cost VCost,
											V.Volume_Incentive,
											V.Planned_Days_In_Service,
											V.Sold_Date,

											(SELECT  PrevMonthAMO.PreBalance  from
												   (
													--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
													SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
													Where Unit_number=DH.Unit_Number  And AMO_Month<@dMonthBeginning
													Order by AMO_Month DESC
													
													) PrevMonthAMO
											) As PreMonthBalance
									
									
						FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
											  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
									
						Where ( DH.Depreciation_End_Date-1>=@dMonthBeginning or   DH.Depreciation_End_Date is null) 
					) AMOBook
					Where @dMonthBeginning>=DB and @dMonthEnd<=DE -1
					--And AMOBook.Unit_Number=164335


			--5
					Union

					Select distinct  
					Unit_Number, 
					Null Valid_From,
					Null Valid_To,
					0 as AMODays,
					MonthlyAMO,
					0.00 AMOAmount,		
					0.00 DepCredit, 
					Volume_Incentive,
					PreMonthBalance,
					@dMonthBeginning MB, 
					@dMonthEnd ME,
					DB,
					DE,
					Sold_Date



					--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dMonthBeginning,  @dMonthEnd) +1),2) as Balanace, 
					--GetDate()

					From 
					(
							SELECT      DH.Unit_Number, 
											Datediff(month, DH.Depreciation_Start_Date,@dMonthBeginning )+1 as LoanMonth,
											(Case WHEN DH.Depreciation_Rate_Amount  Is Null  AND (DH.Depreciation_Rate_Percentage is Not Null AND DH.Depreciation_Rate_Percentage<>0) then Vehicle_Cost*DH.Depreciation_Rate_Percentage/100
													  WHEN DH.Depreciation_Rate_Amount  Is Not Null  THEN  DH.Depreciation_Rate_Amount
													  ELSE 0
											End) MonthlyAMO,
					    
											DH.Depreciation_Start_Date DB, 
											(Case When DH.Depreciation_End_Date Is not Null Then DH.Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End) DE, 
											DH.Depreciation_Rate_Amount RateAmount, 
											DH.Depreciation_Rate_Percentage RatePercentage, 
											V.Vehicle_Cost VCost,
											V.Volume_Incentive,
											V.Planned_Days_In_Service,
											V.Sold_Date,											

											(SELECT  PrevMonthAMO.PreBalance  from
												   (
													--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
													SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
													Where Unit_number=DH.Unit_Number  And AMO_Month<@dMonthBeginning
													Order by AMO_Month DESC
													
													) PrevMonthAMO
											) As PreMonthBalance
						
							FROM   dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
								Inner JOIN
								 (Select Unit_Number,  									
											Max(Depreciation_End_Date)  OSD
									from dbo.FA_Vehicle_Depreciation_History 
										Group By Unit_Number
									) LDH On DH.Unit_Number=LDH.Unit_Number and DH.Depreciation_End_Date=LDH.OSD

									
						Where ( DH.Depreciation_End_Date-1< @dMonthBeginning ) And   
						(	
							(V.Sold_Date>= @dMonthBeginning --and V.Sold_Date<=@dMonthEnd
							)	
							Or
							(V.Sold_Date Is NUll)	
						)
									
						/*FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
											  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
									
						Where ( DH.Depreciation_End_Date-1< @dMonthBeginning ) And (V.Sold_Date>= @dMonthBeginning and V.Sold_Date<=@dMonthEnd)*/

					) AMOBook
					
					--Where AMOBook.Unit_Number=164335

			) VehicleDep

			Group By VehicleDep.Unit_Number,  MB,  ME, DE, PreMonthBalance,Volume_Incentive	,DepCredit,VehicleDep.Volume_Incentive, Sold_Date		
) VehicleAMO
Group By 
VehicleAMO.Unit_Number,  VehicleAMO.MB, VehicleAMO.PreMonthBalance,   VehicleAMO.InserviceMonths,VehicleAMO.Volume_Incentive

IF @Mode='C' 
		BEGIN
				
				Insert into FA_Vehicle_Amortization
				Select * from #FA_Vehicle_Amortization	where AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd

				Declare @iCount Int

				Select @iCount=count(*) from FA_Dep_Lease_Month_End Where FA_Month=@dMonthBeginning 
			
				If @iCount=0
						 Insert into FA_Dep_Lease_Month_End  Values(@dMonthBeginning,  Getdate(), Null)
				Else
						 Update FA_Dep_Lease_Month_End Set Vehicle_AMO_Date=getdate() Where FA_Month=@dMonthBeginning 
 			   
		END
ELSE
			Begin
		  /*Select count(*), Unit_Number from #FA_Vehicle_Amortization
           Group by Unit_Number
			Having count(*)>1*/
		
					SELECT       VMO.AMO_Month,V.Unit_Number, V.Serial_Number, VMY.Model_Name, VMY.Model_Year, 
					 VC.FA_Vehicle_Type_ID, 
					 (Case When V.Lessee_id Is Not NULL Then 'Lease'
							 Else 'Rental'
					 End) VehicleUse,
					VDH.ISD, 
					--@dMonthEnd MonthEnd,
                    -- V.Sold_Date as VOSD,               					
                   (Case When V.Sold_Date>@dMonthEnd Then  NULL
							 When V.Sold_Date is Null Then  NULL
							 When V.Sold_Date<=@dMonthEnd Then V.Sold_Date   --VDH.OSD -- Vehicle Sold Within the Month
					End ) As OSD,
					VTP.LastPFDDAte,
					V.Program, 
                    V.Vehicle_Cost, 
					PrevAMO.Balance as BeginningBalance,
					(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
							 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
							 Else 0
					End) FixedAMO,
					VMO.AMO_Amount, 
					V.Volume_Incentive,
					VMO.Dep_Credit,
					isnull(VOLACCAMO.AccAMO,0)+VMO.Dep_Credit  ACCDepCr,	
					V.Volume_Incentive-(isnull(VOLACCAMO.AccAMO,0)+VMO.Dep_Credit) as UnAmortizedIncentive, 	
					VMO.InService_Months,		
					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then   VMO.Balance		
							  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
					End ) Balance, 							
					
				   (Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then   V.Vehicle_Cost-VMO.Balance 
							  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
					End ) As AccuAMO,

					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  V.Vehicle_Cost
							  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
					End ) As BookCost,
					
					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
							  When V.Sold_Date<=@dMonthEnd Then  V.Vehicle_Cost-- Vehicle Sold With the Month
					End ) As SoldCost,
					
					(Case   When V.Sold_Date<=@dMonthEnd Then  'Yes' -- Vehicle Sold With the Month
								Else ''
					End ) As Sold,

					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
							  When V.Sold_Date<=@dMonthEnd Then  V.Vehicle_Cost-VMO.Balance  -- Vehicle Sold With the Month
					End ) As SoldAMO,
					

					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
							  When V.Sold_Date<=@dMonthEnd Then    V.Selling_Price -- Vehicle Sold Within the Month
					End ) As SellingPrice,
				

					(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
							  When V.Sold_Date<=@dMonthEnd Then  V.Selling_Price-(V.Vehicle_Cost -(V.Vehicle_Cost-VMO.Balance)) -- Vehicle Sold With the Month
					End ) As GainLoss
				

				FROM         #FA_Vehicle_Amortization VMO 
					INNER JOIN
					(
							SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
												dbo.FA_Vehicle_Amortization.AMO_Amount, 
												dbo.FA_Vehicle_Amortization.InService_Months, 
												dbo.FA_Vehicle_Amortization.Balance, 
												dbo.FA_Vehicle_Amortization.AMO_Month
							FROM         dbo.FA_Vehicle_Amortization
							Inner Join 
							(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
														Max(AMO_Month) as AMOMonth
									FROM         dbo.FA_Vehicle_Amortization
									Where dbo.FA_Vehicle_Amortization.AMO_Month<@dMonthBeginning
									Group By Unit_Number
									
							) PrevMonth
							On dbo.FA_Vehicle_Amortization.Unit_Number=PrevMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=PrevMonth.AMOMonth
					 ) PrevAMO										
					On VMO.Unit_Number =PrevAMO.Unit_Number
					INNER JOIN
					(
						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
											SUM(Dep_Credit) as AccAMO
						FROM         dbo.FA_Vehicle_Amortization
                        Where dbo.FA_Vehicle_Amortization.AMO_Month<@dMonthBeginning
									Group By Unit_Number
					
					) VOLACCAMO
 					On VMO.Unit_Number =VOLACCAMO.Unit_Number
					INNER JOIN
                      dbo.Vehicle V ON VMO.Unit_Number = V.Unit_Number 
					INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
					 INNER JOIN
                      dbo.Vehicle_Class VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
                     Inner JOIN
					 (Select Unit_Number,  
								Min(Depreciation_Start_Date) ISD, 
								Max(
										Case When Depreciation_End_Date Is Not Null Then Depreciation_End_Date Else Convert(Datetime, '2078-12-31') End
								)  OSD
						from dbo.FA_Vehicle_Depreciation_History 
 
							 /*where (
												(Depreciation_Start_Date>=@dMonthBeginning and Depreciation_Start_Date <=@dMonthEnd)
											OR   
												(Depreciation_End_Date-1>=@dMonthBeginning AND Depreciation_End_Date-1<=@dMonthEnd)
											OR 
												(Depreciation_Start_Date<=@dMonthBeginning and Depreciation_End_Date-1 >=@dMonthEnd)
										  )*/	
							Group By Unit_Number
						) VDH
                      
					 ON VMO.Unit_Number = VDH.Unit_Number
                      
					Left JOIN
					 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
						dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
						dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
						from dbo.FA_Vehicle_Depreciation_History  
								Inner Join 
								(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
									FROM         FA_Vehicle_Depreciation_History
										where (
												(Depreciation_Start_Date>=@dMonthBeginning and Depreciation_Start_Date <=@dMonthEnd)
											OR   
												(Depreciation_End_Date-1>=@dMonthBeginning AND Depreciation_End_Date-1<=@dMonthEnd)
											OR 
												(Depreciation_Start_Date<=@dMonthBeginning and Depreciation_End_Date-1 >=@dMonthEnd)
										  )	
										Group By Unit_Number									
							) LastDep
							On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
						
						) LastVDH
						On  VMO.Unit_Number =LastVDH.Unit_Number
					Left Join Vehicle_Total_PFD_Days_vw VTP
						On	VMO.Unit_Number =VTP.Unit_Number
							
				WHERE     (VMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)   And V.Owning_Company_ID=(select Code from lookup_table where category = 'BudgetBC Company')         
              -- Remove Beginning Balance entry if it is preview mode ---
			--select DATEADD(month,-1, '2010-09-01')
            --   Delete FA_Vehicle_Amortization where InService_Months=0 and AMO_Month  =DATEADD(month,-1, @dMonthBeginning)
		End

Drop Table #FA_Vehicle_Amortization

RETURN 1
GO
