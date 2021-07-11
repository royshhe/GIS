USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRestrictRentalUseSearchData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRestrictRentalUseSearchData    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictRentalUseSearchData    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictRentalUseSearchData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictRentalUseSearchData    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRestrictRentalUseSearchData]
@BeginUnitNumber varchar(10),
@EndUnitNumber varchar(10),
@CurrentStatusID char(1),
@Model varchar(30),
@CurrentLocationID varchar(20)
AS
Set Rowcount 500

Declare	@nBeginUnitNumber Integer
Declare	@nEndUnitNumber Integer
Declare	@nCurrentLocationID SmallInt

Select		@nBeginUnitNumber = Convert(int,NULLIF(@BeginUnitNumber, ''))
Select		@nEndUnitNumber = Convert(int,NULLIF(@EndUnitNumber, ''))
Select		@CurrentStatusID = NULLIF(@CurrentStatusID, '')
Select		@nCurrentLocationID = Convert(smallint, NULLIF(@CurrentLocationID, ''))

Select Distinct
	V.Unit_Number, V.Serial_Number, VMY.Model_Name, V.Exterior_Colour,
	V.Current_Km, V.Do_Not_Rent_Past_Km - V.Current_Km,
	V.Do_Not_Rent_Past_Days - DateDiff(day, V.Ownership_Date, getDate()),
	L.Location, V.Maximum_Rental_Period
From
	Vehicle V, Vehicle_Model_Year VMY, Location L
Where
	V.Deleted = 0

	And (Foreign_Vehicle_Unit_Number IS NULL Or Foreign_Vehicle_Unit_Number = '')
	And V.Unit_Number >= ISNULL(@nBeginUnitNumber, V.Unit_Number)
	And V.Unit_Number <= ISNULL(@nEndUnitNumber, V.Unit_Number)

	And V.Current_Vehicle_Status = ISNULL(@CurrentStatusID, V.Current_Vehicle_Status)
	And VMY.Model_Name Like LTrim(@Model) + "%"
	And V.Current_Location_ID = ISNULL(@nCurrentLocationID, V.Current_Location_ID)
	And V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	And V.Current_Location_ID = L.Location_ID
Order By V.Unit_Number
Return 1














GO
