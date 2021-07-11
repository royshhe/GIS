USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_9b_Vehicle_Due_Back_By_Hourly]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*
PROCEDURE NAME: RP_SP_Flt_9_Vehicle_Due_Back_By_Hourly
PURPOSE: Select all information needed for Vehicle Due Back by Hourly Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:  Vehicle Due Back by Hourly Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/02	Exclude foreign vehicles
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/

CREATE PROCEDURE [dbo].[RP_SP_Flt_9b_Vehicle_Due_Back_By_Hourly]
(
	@paramVehicleTypeID varchar(18) = '*',
	@paramDueBackLocationID varchar(20) = '*',
	@paramDueBackDate varchar(20) = '01 September 1999',
	@paramHubID varchar(6)='*'
)

AS
-- convert strings to datetime

DECLARE 	@dueBackDate datetime

SELECT	@dueBackDate	= CONVERT(datetime, '00:00:00 ' + @paramDueBackDate)

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramDueBackLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramDueBackLocationID
	END 

DECLARE  @intHubID varchar(6)

if @paramHubID = ''
	select @paramHubID = '*'

if @paramHubID = '*'
	BEGIN
		SELECT @intHubID='0'
        END
else
	BEGIN
		SELECT @intHubID = @paramHubID
	END 

-- end of fixing the problem



SELECT	Vehicle_On_Contract.Expected_Check_In,
    	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)) AS Expected_Check_In_Date,
	DATEPART(hh,  Vehicle_On_Contract.Expected_Check_In) AS Expected_Check_In_Hour,
	Vehicle_Class.Vehicle_Type_ID,
    	--Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	Right(Convert(char(03), Vehicle_Class.DisplayOrder+100),2)+' - '+Vehicle_Class.Vehicle_Class_Name Vehicle_Class_Code_Name,			 	-- Vehicle class name
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID AS Expected_Check_In_Location_ID,
     	Location.Location AS Expected_Check_In_Location_Name,
    	COUNT(Vehicle_On_Contract.Contract_Number) AS Contract_Cnt

FROM 	Contract with(nolock)
	INNER JOIN
    	Vehicle_On_Contract
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
     	INNER JOIN
    	Vehicle
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
	INNER JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Location
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 	-- location has to be rental location
	INNER JOIN
	Lookup_Table lt1
		ON lt1.Code = Location.Owning_Company_ID
		AND lt1.Category = 'BudgetBC Company'	-- drop off location has to be a BRAC BC location
	INNER JOIN
	Lookup_Table lt2
		ON lt2.Code = Vehicle.Owning_Company_ID
		AND lt2.Category = 'BudgetBC Company'	-- BRAC BC vehicles

WHERE 	--(Contract.Status = 'CO')
	--AND
	--(Vehicle_On_Contract.Actual_Check_In IS NULL)
	--AND
	--Vehicle.Deleted = 0
	--AND
	(@paramVehicleTypeID = '*' OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramDueBackLocationID = '*' or CONVERT(INT, @tmpLocID) = Vehicle_On_Contract.Expected_Drop_Off_Location_ID)
	AND
	DATEDIFF(dd, @dueBackDate, Vehicle_On_Contract.Expected_Check_In) = 0
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = location.Hub_ID)

GROUP BY 	
	Vehicle_On_Contract.Expected_Check_In,
    	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)),
	DATEPART(hh, Vehicle_On_Contract.Expected_Check_In),
    	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID,
    	Location.Location,
	Vehicle_Class.Vehicle_Class_Code,Vehicle_Class.DisplayOrder
	
	order by Vehicle_Class.DisplayOrder


RETURN @@ROWCOUNT


GO
