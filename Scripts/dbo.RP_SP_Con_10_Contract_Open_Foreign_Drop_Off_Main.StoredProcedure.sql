USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_10_Contract_Open_Foreign_Drop_Off_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Programmer :	Vivian Leung
--Date :	Apr 01 2004
--Details:	THIS SP IS USED IN THE MAIN REPORT OF THE CALGARY ADHOC REPORT.
--		REPORT SHOWS ALL CONTRACT OPENED THAT DROP TO CALGARY LOCATIONS
--		Futher modifications needed if want to use @Config
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RP_SP_Con_10_Contract_Open_Foreign_Drop_Off_Main]

(
	@Config varchar(20) = 'Contract out',
	@paramStartDate varchar(20) = '01 jun 2003',
	@paramEndDate varchar(20) = '20 jun 2003',
	@paramPULocID varchar(20) = '*',
	@paramDOLocOCID varchar(20) = '*'
)
AS

-- convert strings to datetime

DECLARE 	@startDate datetime,
		@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
		@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)


-- fix upgrading problem (SQL7->SQL2000)

DECLARE	@tmpDOLocOCID varchar(20),
		@tmpPULocID varchar(20)

if @paramPULocID = '*'
	BEGIN
		SELECT @tmpPULocID= '0'
        END
else
	BEGIN
		SELECT @tmpPULocID = @paramPULocID
	END

if @paramDOLocOCID = '*'
	BEGIN
		SELECT @tmpDOLocOCID= '0'
        END
else
	BEGIN
		SELECT @tmpDOLocOCID = @paramDOLocOCID
	END 

-- end of fixing the problem


SELECT 	Configuration,
	Status,
	Vehicle_Type_ID, 
	RBR_Date,
	Contract_Number, 
    	Foreign_Contract_Number, 
    	Customer_Name, 
	Unit_Number, 
	Current_Licence_plate,
	Model_Name, 
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Vehicle_Owning_Company,
	Pick_Up_Location_ID,
    	Pick_Up_Location_Name, 
	ExpectedDropOffLocID,
	ExpectedDropOffLoc,
	ExpectedDOLocOCID,
	ExpectedDOOCName,
	ActualDropOffLocID,
	ActualDropOffLoc,
	ActualDOLocOCID,
	Check_Out_Date,	-- date contract is actually checked out
	Check_In_Date,		-- date contract is expected checked in
	Pre_Authorization_Method,
	Payment_Type,
	Advance_Deposit = sum(Advance_Deposit)
from
RP_Con_10_Contract_Open_Foreign_Drop_Off_Main
where 	RBR_Date between @startDate and @endDate
and 	(@paramDOLocOCID = '*'
		or ExpectedDOLocOCID = CONVERT(INT, @tmpDOLocOCID)
		--or ActualDOLocOCID = CONVERT(INT, @tmpDOLocOCID)
	)
and	(@paramPULocID = '*' or Pick_Up_Location_ID = Convert(int, @tmpPULocID))
group by Configuration,
	Status,
	Vehicle_Type_ID, 
	RBR_Date,
	Contract_Number, 
    	Foreign_Contract_Number, 
    	Customer_Name, 
	Unit_Number, 
	Current_Licence_plate,
	Model_Name, 
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Vehicle_Owning_Company,
	Pick_Up_Location_ID,
    	Pick_Up_Location_Name, 
	ExpectedDropOffLocID,
	ExpectedDropOffLoc,
	ExpectedDOLocOCID,
	ExpectedDOOCName,
	ActualDropOffLocID,
	ActualDropOffLoc,
	ActualDOLocOCID,
	Check_Out_Date,
	Check_In_Date,
	Pre_Authorization_Method,
	Payment_Type
GO
