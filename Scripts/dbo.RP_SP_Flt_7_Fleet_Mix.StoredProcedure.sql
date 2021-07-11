USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_7_Fleet_Mix]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/*
PROCEDURE NAME: RP_SP_Flt_7_Fleet_Mix
PURPOSE: Select all information needed for Fleet Mix Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/20
USED BY:  Fleet Mix Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/21	Exclude deleted vehicles

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_7_Fleet_Mix]
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
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


if @intHubID<>9 AND @intHubID<>14

BEGIN
SELECT 	Vehicle.Unit_Number,
	Vehicle_Class.Vehicle_Type_ID,
    	Location.Location AS Current_Location_Name,
    	Vehicle.Current_Rental_Status AS Vehicle_Rental_Status,
    	Vehicle_Class.Vehicle_Class_Code,
    	Vehicle_Class.alias as Vehicle_Class_Name,
	Vehicle_Class.DisplayOrder,
    	Vehicle.Current_Location_ID
             
FROM 	Vehicle with(nolock)
	INNER JOIN
    	Location
		ON  Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Lookup_Table
		ON Vehicle.Owning_Company_ID = CONVERT(smallint,Lookup_Table.Code)
WHERE   Vehicle.Current_Vehicle_Status = 'd'
	AND
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = "*" OR Vehicle_Class.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Vehicle.Current_Location_ID)
	AND
	(@paramHubID = "*" or CONVERT(INT, @intHubID) = Location.Hub_ID)
        --(@paramHubID = "*" or  Location.Hub_ID<>9)
	AND
	Vehicle.Deleted = 0
END
else
BEGIN
SELECT 	Vehicle.Unit_Number,
	Vehicle_Class.Vehicle_Type_ID,
    	Location.Location AS Current_Location_Name,
    	Vehicle.Current_Rental_Status AS Vehicle_Rental_Status,
    	Vehicle_Class.Vehicle_Class_Code,
    	Vehicle_Class.alias as Vehicle_Class_Name,
	Vehicle_Class.DisplayOrder,
    	Vehicle.Current_Location_ID
             
FROM 	Vehicle with(nolock)
	INNER JOIN
    	Location
		ON  Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Lookup_Table
		ON Vehicle.Owning_Company_ID = CONVERT(smallint,Lookup_Table.Code)
WHERE   Vehicle.Current_Vehicle_Status = 'd'
	AND
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = "*" OR Vehicle_Class.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Vehicle.Current_Location_ID)
	AND
	(@paramHubID = "*" or CONVERT(INT, @intHubID) = Location.Hub_ID)
        --(@paramHubID = "*" or  Location.Hub_ID<>9)
	AND
	Vehicle.Deleted = 0

END



GO
