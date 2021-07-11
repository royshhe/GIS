USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_CreateLeaseAmotization]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[FA_CreateLeaseAmotization]  -- '2008-03-01', 'V'

	@AMOMonth VarChar(24),
	@Mode CHAR(1)='C'
As


--Vehicle  AMO Case					
--			Starting	Ending	
--1		MB	AB	AE	ME
--2		MB	AB	ME	AE
--3		AB	MB	AE	ME
--4		AB	MB	ME	AE
 
DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime
Declare @GSTRate decimal(9,2)
Declare @PSTRate decimal(9,2)

SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1

Select @GSTRate=Tax_Rate from Tax_Rate where (@dMonthBeginning between  Tax_Rate.Valid_From And  Tax_Rate.Valid_To) And (Tax_Type='GST' or Tax_Type='HST' )
Select @PSTRate=Tax_Rate  from Tax_Rate where (@dMonthBeginning between  Tax_Rate.Valid_From And  Tax_Rate.Valid_To)  And Tax_Type='PST'


CREATE TABLE #FA_Lease_Amortization (
	[Unit_number] [int] NOT NULL ,
	[Lessee_ID] [smallint] NOT NULL ,
	[AMO_Month] [datetime] NOT NULL ,
	[Principle] [decimal](9, 2) NULL ,
	[Interest] [decimal](9, 2) NULL ,
	[Last_Updated_On] Datetime NULL
)

 
--Delete #FA_Vehicle_Amortization
--Insert 


/*
Delete FA_Vehicle_Amortization where AMO_Month=@dMonthBeginning
Insert into FA_Vehicle_Amortization
*/
INSERT INTO  #FA_Lease_Amortization
Select   Unit_Number,  
			Lessee_id, 
			MB, 
			SUM(AMOAmount) as Principle, 
			SUM(InterestAmount) as Interest,            
			GetDate() as LastUpdatedOn			
					
From
(

-- Case 1
--1		MB	AB	AE	ME		
       Select distinct -- 'A1' as Type,
		Unit_Number, 
		Lessee_id, 
		Initial_Cost, 
		LB Valid_From,
		LE-1 Valid_To,
		Datediff(Day,  LB,  LE-1) +1 as AMODays,
		MonthlyAMO,
        (Case When Datediff(Day,  LB,  LE-1) +1=Datediff(Day, MB, ME) +1 Then MonthlyAMO 
				 Else Round((MonthlyAMO*12/365)*(Datediff(Day,  LB,  LE-1) +1),2)
		End)		 AMOAmount,	
		Round(Initial_Cost*(Interest_Rate/100.00)/12,2) InterestAmount, 
		MB, 
		ME,
		LB,
		LE
	
		From 
		(
				SELECT    
						 Unit_Number, 
						 Lessee_id, 
						 Initial_Cost,
						 Interest_Rate,
						 Principle_Rate MonthlyAMO, 
						 Lease_Start_Date LB, 
						 (Case when Lease_End_Date is Not Null  Then Lease_End_Date Else '2078-12-31' End) LE, 
						@dMonthBeginning MB, 
						@dMonthEnd ME
		FROM      dbo.FA_Vehicle_Lease_History LH
		Where (	(Lease_Start_Date>=@dMonthBeginning and Lease_Start_Date <=@dMonthEnd)
				OR   
					(Lease_End_Date-1>=@dMonthBeginning AND Lease_End_Date-1<=@dMonthEnd)

				--- Including whole month
				OR 	
					(Lease_Start_Date<=@dMonthBeginning and Lease_End_Date-1 >=@dMonthEnd)

				OR 
					(Lease_Start_Date<=@dMonthBeginning	AND  Lease_End_Date is null) )  
		) AMOBook
		Where LB>=@dMonthBeginning and LE-1<=@dMonthEnd
		 --And AMOBook.Unit_Number=164335


		-- Case 2
		Union

		Select distinct  -- 'A2' as Type,
		Unit_Number, 
		Lessee_id, 
		Initial_Cost, 
		LB Valid_From,
		ME Valid_To,
		Datediff(Day,  LB,  ME) +1 as AMODays,
		MonthlyAMO,
        (Case When LB=MB Then MonthlyAMO 
				 Else Round((MonthlyAMO*12/365)*(Datediff(Day,  LB,  ME) +1),2)
		End)		 AMOAmount,	
		Round(Initial_Cost*(Interest_Rate/100.00)/12,2) InterestAmount, 
		MB, 
		ME,
		LB,
		LE
	
		From 
		(
				SELECT    
						 Unit_Number, 
						 Lessee_id, 
						 Initial_Cost,
						 Interest_Rate,
						 Principle_Rate MonthlyAMO, 
						 Lease_Start_Date LB, 
						 (Case when Lease_End_Date is Not Null  Then Lease_End_Date Else '2078-12-31' End) LE, 
						@dMonthBeginning MB, 
						@dMonthEnd ME
		FROM      dbo.FA_Vehicle_Lease_History LH
		Where (	(Lease_Start_Date>=@dMonthBeginning and Lease_Start_Date <=@dMonthEnd)
				OR   
					(Lease_End_Date-1>=@dMonthBeginning AND Lease_End_Date-1<=@dMonthEnd)

				--- Including whole month
				OR 	
					(Lease_Start_Date<=@dMonthBeginning and Lease_End_Date-1 >=@dMonthEnd)

				OR 
					(Lease_Start_Date<=@dMonthBeginning	AND  Lease_End_Date is null) )  
		) AMOBook

		Where LB>=@dMonthBeginning  And LB<=@dMonthEnd and (@dMonthEnd<=LE-1 or LE is Null)
		 --And AMOBook.Unit_Number=164335

		--3
		Union

		Select distinct   --'A3' as Type,
		Unit_Number, 
		Lessee_id, 
		Initial_Cost, 
		LB Valid_From,
		ME Valid_To,
		Datediff(Day,  MB,  LE-1) +1 as AMODays,
		MonthlyAMO,
        (Case When LE-1=ME Then MonthlyAMO 
				 Else Round((MonthlyAMO*12/365)*(Datediff(Day,  MB,  LE-1) +1),2)
		End)		 AMOAmount,	
		Round(Initial_Cost*(Interest_Rate/100.00)/12,2) InterestAmount, 
		MB, 
		ME,
		LB,
		LE
	
		From 
		(
				SELECT    
						 Unit_Number, 
						 Lessee_id, 
						 Initial_Cost,
						 Interest_Rate,
						 Principle_Rate MonthlyAMO, 
						 Lease_Start_Date LB, 
						 (Case when Lease_End_Date is Not Null  Then Lease_End_Date Else '2078-12-31' End) LE, 
						@dMonthBeginning MB, 
						@dMonthEnd ME
		FROM      dbo.FA_Vehicle_Lease_History LH
		Where (	(Lease_Start_Date>=@dMonthBeginning and Lease_Start_Date <=@dMonthEnd)
				OR   
					(Lease_End_Date-1>=@dMonthBeginning AND Lease_End_Date-1<=@dMonthEnd)

				--- Including whole month
				OR 	
					(Lease_Start_Date<=@dMonthBeginning and Lease_End_Date-1 >=@dMonthEnd)

				OR 
					(Lease_Start_Date<=@dMonthBeginning	AND  Lease_End_Date is null) )  
		) AMOBook

		Where MB>=LB and MB<=LE-1 And LE-1<=@dMonthEnd
		 --And AMOBook.Unit_Number=164335

		--4
		Union 

		Select distinct   --'A4' as Type,
		Unit_Number, 
		Lessee_id, 
		Initial_Cost, 
		LB Valid_From,
		ME Valid_To,
		Datediff(Day,  MB,  ME) +1 as AMODays,
		MonthlyAMO,
        MonthlyAMO AMOAmount,	
		Round(Initial_Cost*(Interest_Rate/100.00)/12,2) InterestAmount, 
		MB, 
		ME,
		LB,
		LE
	
		From 
		(
				SELECT    
						Unit_Number, 
						Lessee_id, 
						Initial_Cost,
						Interest_Rate,
						Principle_Rate MonthlyAMO, 
						Lease_Start_Date LB, 
						(Case when Lease_End_Date is Not Null  Then Lease_End_Date Else '2078-12-31' End) LE, 
						@dMonthBeginning MB, 
						@dMonthEnd ME
		FROM      dbo.FA_Vehicle_Lease_History LH
		Where (	(Lease_Start_Date>=@dMonthBeginning and Lease_Start_Date <=@dMonthEnd)
				OR   
					(Lease_End_Date-1>=@dMonthBeginning AND Lease_End_Date-1<=@dMonthEnd)

				--- Including whole month
				OR 	
					(Lease_Start_Date<=@dMonthBeginning and Lease_End_Date-1 >=@dMonthEnd)

				OR 
					(Lease_Start_Date<=@dMonthBeginning	AND  Lease_End_Date is null) )  
		) AMOBook
		Where MB>=LB and (ME<=LE -1 or LE IS Null)
		 --And AMOBook.Unit_Number=164335

) VehicleLease

Group By VehicleLease.Unit_Number,    Lessee_id, 	MB 	

IF @Mode='C' 
		BEGIN
				Delete FA_Lease_Amortization where AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd
				Insert into FA_Lease_Amortization
				Select * from #FA_Lease_Amortization	where AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd

				Declare @iCount Int

				Select @iCount=count(*) from FA_Dep_Lease_Month_End Where FA_Month=@dMonthBeginning 
			
				If @iCount=0
						 Insert into FA_Dep_Lease_Month_End  Values(@dMonthBeginning,  NULL, GetDate())
				Else
						 Update FA_Dep_Lease_Month_End Set Lease_AMO_Date=getdate() Where FA_Month=@dMonthBeginning 
 
 			   
		END
ELSE
			Begin
		
				SELECT   V.Unit_Number, 
								V.Serial_Number, VMY.Model_Name +' - ' + Convert(Varchar(4),  VMY.Model_Year) as Model_Name, LH.Lease_Start_Date, LH.Private_Lease, LH.Lease_End_Date, 
								LAMO.Lessee_ID, LAMO.AMO_Month, LAMO.Principle, LAMO.Interest,
								dbo.FA_Lessee.Lessee_Name, 
								Round((LAMO.Principle+LAMO.Interest)*(@GSTRate/100),2) as GSTAmount ,
								(Case 
										When LH.Private_Lease =1 Then Round((LAMO.Principle+LAMO.Interest)*(@PSTRate/100),2)
										Else 0
								 End) as PSTAmount

				FROM           #FA_Lease_Amortization LAMO 
										INNER JOIN 
												(
													Select * from dbo.FA_Vehicle_Lease_History    
													Where (	
																(Lease_Start_Date>=@dMonthBeginning and Lease_Start_Date <=@dMonthEnd)
															OR   
																(Lease_End_Date-1>=@dMonthBeginning AND Lease_End_Date-1<=@dMonthEnd)

															--- Including whole month
															OR 	
																(Lease_Start_Date<=@dMonthBeginning and Lease_End_Date-1 >=@dMonthEnd)

															OR 
																(Lease_Start_Date<=@dMonthBeginning	AND  Lease_End_Date is null) )  

												)LH 
												ON LAMO.Unit_number = LH.Unit_Number AND LAMO.Lessee_ID = LH.Lessee_id 
									INNER JOIN
									  dbo.Vehicle V ON LAMO.Unit_number = V.Unit_Number INNER JOIN
									  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
									  dbo.FA_Lessee ON LH.Lessee_id = dbo.FA_Lessee.Lessee_ID
								
							
				WHERE     (LAMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)   
		End

Drop Table #FA_Lease_Amortization

RETURN 1

GO
