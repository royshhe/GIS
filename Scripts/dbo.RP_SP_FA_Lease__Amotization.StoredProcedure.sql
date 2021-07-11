USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Lease__Amotization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[RP_SP_FA_Lease__Amotization]   --'01 jan 2010','MILLER ROAD HOLDINGS LTD.dba.PARK N FLY'

	@AMOMonth VarChar(24),
	@LesseeName Varchar(50)
	
As
--
--
--			Starting	Ending	
--1		MB	LB	LE-1	 ME
--2		MB	LB	ME	 LE-1
--3		LB	MB	LE-1	 ME
--4		LB	MB	ME	 LE-1
--
-- 
DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime
Declare @GSTRate decimal(9,2)
Declare @PSTRate decimal(9,2)

SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1

Select @GSTRate=Tax_Rate from Tax_Rate where (@dMonthBeginning between  Tax_Rate.Valid_From And  Tax_Rate.Valid_To) And (Tax_Type='GST' or Tax_Type='HST')
Select @PSTRate=Tax_Rate  from Tax_Rate where (@dMonthBeginning between  Tax_Rate.Valid_From And  Tax_Rate.Valid_To)  And Tax_Type='PST'


		
		SELECT   V.Unit_Number, 
						V.Serial_Number, VMY.Model_Name + ' - ' +Convert(varchar(4), VMY.Model_Year) as Model_Name, LH.Lease_Start_Date, LH.Private_Lease, LH.Lease_End_Date, 
						LAMO.Lessee_ID, LAMO.AMO_Month, LAMO.Principle, LAMO.Interest,
						dbo.FA_Lessee.Lessee_Name, 
						Round((LAMO.Principle+LAMO.Interest)*(@GSTRate/100),2) as GSTAmount ,
						(Case 
								When LH.Private_Lease =1 Then Round((LAMO.Principle+LAMO.Interest)*(@PSTRate/100),2)
								Else 0
						 End) as PSTAmount

		FROM           FA_Lease_Amortization LAMO 
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
						
					
		WHERE     (LAMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd) and
					(@LesseeName='*' or dbo.FA_Lessee.Lessee_Name=@LesseeName )
GO
