USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTurnBackUpdateSearchData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetTurnBackUpdateSearchData    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetTurnBackUpdateSearchData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetTurnBackUpdateSearchData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetTurnBackUpdateSearchData    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetTurnBackUpdateSearchData]
@BeginUnitNumber varchar(10),
@EndUnitNumber varchar(10),
@CurrentStatusID char(1),
@Model varchar(30),
@MonthAcquired varchar(20)
AS
Set Rowcount 500

Declare	@nBeginUnitNumber Integer
Declare	@nEndUnitNumber Integer

Select		@nBeginUnitNumber = Convert(int,NULLIF(@BeginUnitNumber, ''))
Select		@nEndUnitNumber = Convert(int,NULLIF(@EndUnitNumber, ''))
Select		@CurrentStatusID = NULLIF(@CurrentStatusID, '')
Select		@MonthAcquired = NULLIF(@MonthAcquired, '')

Select Distinct
	V.Unit_Number, V.Serial_Number, VMY.Model_Name, V.Maximum_Km,
	V.Do_Not_Rent_Past_Km, V.Reconditioning_Days_Allowed,
	V.Do_Not_Rent_Past_Days - DateDiff(day, V.Ownership_Date, getDate()),
	Convert(char(1),V.Program), V.Minimum_Days, V.Maximum_Days,
	V.Do_Not_Rent_Past_Days, V.Exterior_Colour, V.Ownership_Date
From

	Vehicle V, Vehicle_Model_Year VMY
Where
	V.Deleted=0
	And (V.Foreign_Vehicle_Unit_Number IS NULL Or V.Foreign_Vehicle_Unit_Number = '')
	And V.Unit_Number >= ISNULL(@nBeginUnitNumber, V.Unit_Number)
	And V.Unit_Number <= ISNULL(@nEndUnitNumber, V.Unit_Number)
	And V.Current_Vehicle_Status = ISNULL(@CurrentStatusID, V.Current_Vehicle_Status)
	And VMY.Model_Name Like LTrim(@Model) + "%"
	
	And (DatePart(month, V.Ownership_Date) = ISNULL(DatePart(month, Convert(datetime, @MonthAcquired)), DatePart(month, V.Ownership_Date)) OR (V.Ownership_Date IS NULL AND @MonthAcquired IS NULL))
	And (DatePart(year, V.Ownership_Date) = ISNULL(DatePart(year, Convert(datetime, @MonthAcquired)), DatePart(year, V.Ownership_Date)) OR (V.Ownership_Date IS NULL AND @MonthAcquired IS NULL))
	And V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	And V.Unit_Number >= @nBeginUnitNumber
Order By V.Unit_Number
Return 1















GO
