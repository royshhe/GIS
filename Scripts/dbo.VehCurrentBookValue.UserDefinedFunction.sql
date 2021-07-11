USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[VehCurrentBookValue]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function  [dbo].[VehCurrentBookValue]
(
	@pIntUnit_Number Int,
    @dtCurrentDate DateTime
)  
RETURNS decimal(9,2) 
As

Begin
Declare @dLastAMOMonth DateTime
Declare @dPeriodBeginning Datetime
Declare @dPeriodEnd Datetime
Declare @lDmlCurrentBookValue decimal(9,2) 
Declare @PreMonthBalance decimal(9,2) 
Declare @CurrentAMOAmount decimal(9,2) 
Declare @VehicleCost decimal(9,2) 

Select @dPeriodEnd=@dtCurrentDate-1


Select @VehicleCost=Vehicle_Cost from Vehicle where Unit_Number=@pIntUnit_Number

SELECT     @dLastAMOMonth=dbo.FA_Vehicle_Amortization.AMO_Month
FROM         dbo.FA_Vehicle_Amortization
Inner Join 
(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
							Max(AMO_Month) as AMOPeriod
		FROM         dbo.FA_Vehicle_Amortization							
		Group By Unit_Number								
) LastMonth
On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOPeriod
Where dbo.FA_Vehicle_Amortization.Unit_number=@pIntUnit_Number

If @dLastAMOMonth is Not Null 
    --Select @dPeriodBeginning=DATEADD(month,1, (@dLastAMOMonth-Day(@dLastAMOMonth)))+1
	Select @dPeriodBeginning=DATEADD(month,1, (@dLastAMOMonth-Day(@dLastAMOMonth) +1))
Else
	Select @dPeriodBeginning=  MIN(Depreciation_Start_Date) from dbo.FA_Vehicle_Depreciation_History  where Unit_Number=@pIntUnit_Number
	
Select @PreMonthBalance=	VehicleDep.PreMonthBalance,@CurrentAMOAmount	=SUM(VehicleDep.AMOAmount)
					
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
		Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  DB,  DE-1) +1),2) DepCredit, 
		Volume_Incentive,
		(Case When PreMonthBalance Is Null Then VCost  Else PreMonthBalance End) PreMonthBalance,
		@dPeriodBeginning MB, 
		@dPeriodEnd ME,
		DB,
		DE
	
		From 
			(
				SELECT      DH.Unit_Number, 
								Datediff(month, DH.Depreciation_Start_Date,@dPeriodBeginning )+1 as LoanMonth,
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
								
						(SELECT  PrevMonthAMO.PreBalance  from
							   (
								--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
								SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=DH.Unit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
								
								) PrevMonthAMO
						) As PreMonthBalance
						
						
			FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
						
			Where ( DH.Depreciation_End_Date-1>=@dPeriodBeginning or   DH.Depreciation_End_Date is null) 
		) AMOBook
		Where DB>=@dPeriodBeginning and DE-1<=@dPeriodEnd
		  And AMOBook.Unit_Number=@pIntUnit_Number


		-- Case 2
		Union

		Select distinct  
		Unit_Number, 
		DB Valid_From,
		@dPeriodEnd Valid_To,
		Datediff(Day,  DB,  @dPeriodEnd) +1 as AMODays,
		MonthlyAMO,
		Round((MonthlyAMO*12/365)*(Datediff(Day,  DB,  @dPeriodEnd) +1),2) AMOAmount,
		Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  DB,  @dPeriodEnd) +1),2) DepCredit, 
		Volume_Incentive,		
		(Case When PreMonthBalance Is Null Then VCost  Else PreMonthBalance End) PreMonthBalance,
		@dPeriodBeginning MB, 
		@dPeriodEnd ME,
		DB,
		DE
	
		From 
			(
				SELECT      DH.Unit_Number, 
								Datediff(month, DH.Depreciation_Start_Date,@dPeriodBeginning )+1 as LoanMonth,
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

						(SELECT  PrevMonthAMO.PreBalance  from
							   (
								--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
								SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=DH.Unit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
								
								) PrevMonthAMO
						) As PreMonthBalance
						
						
			FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
						
			Where ( DH.Depreciation_End_Date-1>=@dPeriodBeginning or   DH.Depreciation_End_Date is null) 
		) AMOBook
		Where DB>=@dPeriodBeginning  And DB<=@dPeriodEnd and @dPeriodEnd<=DE-1
		  And AMOBook.Unit_Number=@pIntUnit_Number

		--3
		Union

		Select distinct  
		Unit_Number, 
		@dPeriodBeginning Valid_From,
		DE-1 Valid_To,
		Datediff(Day,  @dPeriodBeginning,  DE-1) +1 as AMODays,
		MonthlyAMO,
		Round((MonthlyAMO*12/365)*(Datediff(Day,  @dPeriodBeginning,  DE-1) +1),2) AMOAmount,		
		Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  @dPeriodBeginning,  DE-1) +1 ),2) DepCredit, 
		Volume_Incentive,
		(Case When PreMonthBalance Is Null Then VCost  Else PreMonthBalance End) PreMonthBalance,
		@dPeriodBeginning MB, 
		@dPeriodEnd ME,
		DB,
		DE
		--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dPeriodBeginning,  DE-1) +1),2) as Balanace, 
		--GetDate()

		From 
			(
				SELECT      DH.Unit_Number, 
								Datediff(month, DH.Depreciation_Start_Date,@dPeriodBeginning )+1 as LoanMonth,
			
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

						(SELECT  PrevMonthAMO.PreBalance  from
							   (
								--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
								SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=DH.Unit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
								
								) PrevMonthAMO
						) As PreMonthBalance
						
						
			FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
						
			Where ( DH.Depreciation_End_Date-1>=@dPeriodBeginning or   DH.Depreciation_End_Date is null) 
		) AMOBook
		Where @dPeriodBeginning>=DB and @dPeriodBeginning<=DE-1 And DE-1<=@dPeriodEnd
		  And AMOBook.Unit_Number=@pIntUnit_Number

		--4
		Union

		Select distinct  
		Unit_Number, 
		@dPeriodBeginning Valid_From,
		@dPeriodEnd Valid_To,
		Datediff(Day,  @dPeriodBeginning,  @dPeriodEnd) +1 as AMODays,
		MonthlyAMO,
		Round((MonthlyAMO*12/365)*(Datediff(Day,  @dPeriodBeginning,  @dPeriodEnd) +1),2) AMOAmount,		
		Round((Volume_Incentive/Planned_Days_In_Service)*(Datediff(Day,  @dPeriodBeginning,  @dPeriodEnd) +1),2) DepCredit, 
		Volume_Incentive,
		(Case When PreMonthBalance Is Null Then VCost  Else PreMonthBalance End) PreMonthBalance,
		@dPeriodBeginning MB, 
		@dPeriodEnd ME,
		DB,
		DE
		--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dPeriodBeginning,  @dPeriodEnd) +1),2) as Balanace, 
		--GetDate()

		From 
			(
				SELECT      DH.Unit_Number, 
								Datediff(month, DH.Depreciation_Start_Date,@dPeriodBeginning )+1 as LoanMonth,
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

						(SELECT  PrevMonthAMO.PreBalance  from
							   (
								--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
								SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=DH.Unit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
								
								) PrevMonthAMO
						) As PreMonthBalance
						
						
			FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
						
			Where ( DH.Depreciation_End_Date-1>=@dPeriodBeginning or   DH.Depreciation_End_Date is null) 
		) AMOBook
		Where @dPeriodBeginning>=DB and @dPeriodEnd<=DE -1
		  And AMOBook.Unit_Number=@pIntUnit_Number


--5
		Union

		Select distinct  
		Unit_Number, 
		@dPeriodBeginning Valid_From,
		@dPeriodEnd Valid_To,
		0 as AMODays,
		MonthlyAMO,
		0.00 AMOAmount,		
		0.00 DepCredit, 
		Volume_Incentive,
		(Case When PreMonthBalance Is Null Then VCost  Else PreMonthBalance End) PreMonthBalance,
		@dPeriodBeginning MB, 
		@dPeriodEnd ME,
		DB,
		DE



		--PreMonthBalance-Round((MonthlyAMO*12/365)*(Datediff(Day,  @dPeriodBeginning,  @dPeriodEnd) +1),2) as Balanace, 
		--GetDate()

		From 
			(
				SELECT      DH.Unit_Number, 
								Datediff(month, DH.Depreciation_Start_Date,@dPeriodBeginning )+1 as LoanMonth,
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

						(SELECT  PrevMonthAMO.PreBalance  from
							   (
								--SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
								SELECT  Top 1   Balance PreBalance, AMO_Month FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=DH.Unit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
								
								) PrevMonthAMO
						) As PreMonthBalance
			
			FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
					  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
					Inner JOIN
					 (Select Unit_Number,  									
								Max(Depreciation_End_Date)  OSD
						from dbo.FA_Vehicle_Depreciation_History 
							Group By Unit_Number
						) LDH On DH.Unit_Number=LDH.Unit_Number and DH.Depreciation_End_Date=LDH.OSD

						
			Where ( LDH.OSD-1< @dPeriodBeginning ) --And   (V.OSD>= @dPeriodBeginning and V.OSD<=@dPeriodEnd)	
						
			/*FROM         dbo.FA_Vehicle_Depreciation_History AS DH INNER JOIN
								  dbo.Vehicle AS V ON DH.Unit_Number = V.Unit_Number
						
			Where ( DH.Depreciation_End_Date-1< @dPeriodBeginning ) And (V.OSD>= @dPeriodBeginning and V.OSD<=@dPeriodEnd)*/

		) AMOBook
		
	  Where    AMOBook.Unit_Number=@pIntUnit_Number

) VehicleDep

Group By VehicleDep.Unit_Number,  MB,  PreMonthBalance--,Volume_Incentive


If @PreMonthBalance Is Null 
Select @PreMonthBalance=
		(SELECT  Top 1   Balance PreBalance  FROM         dbo.FA_Vehicle_Amortization	
								Where Unit_number=@pIntUnit_Number  And AMO_Month<@dPeriodBeginning
								Order by AMO_Month DESC
		)

Select   

@lDmlCurrentBookValue=
         
		(Case When  @dPeriodBeginning is Not Null And @CurrentAMOAmount Is Not Null And @PreMonthBalance Is Not Null Then
         					(Case When @PreMonthBalance-@CurrentAMOAmount>=0 Then
									@PreMonthBalance-@CurrentAMOAmount
							  Else
									0
							End) 
				When  @dPeriodBeginning is Not Null And @PreMonthBalance Is Not Null  And @CurrentAMOAmount Is  Null  Then
				--When  @dPeriodBeginning is Not Null And @CurrentAMOAmount Is  Null And @PreMonthBalance Is  Null Then
						   @PreMonthBalance
				When  @dPeriodBeginning is Null And @CurrentAMOAmount Is  Null And @PreMonthBalance Is   Null Then
							@VehicleCost
		End)


		Return @lDmlCurrentBookValue
End
GO
