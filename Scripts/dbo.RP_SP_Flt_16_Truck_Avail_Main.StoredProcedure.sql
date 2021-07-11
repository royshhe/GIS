USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_16_Truck_Avail_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 11/23/98 3:55:34 PM ******/

 
	
CREATE PROCEDURE [dbo].[RP_SP_Flt_16_Truck_Avail_Main]  --'7425', '*','*','2012-08-30', '2012-09-01'

    @paramCompanyID	   varchar(20) = '5555',
	@LocId Varchar(5),
	@VehClassCode Varchar(1),
	@StartDate Varchar(24),
	@EndDate Varchar(24)
AS
	/* 10/5/99 - NP - @StartDate, @EndDate varchar(11) -> 24 */
	
	
	-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpLocID varchar(20), 
		@tmpOwningCompanyID varchar(20)

if @LocId = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @LocId
	END 

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpOwningCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpOwningCompanyID = @paramCompanyID
	END
-- end of fixing the problem


 
DECLARE @dStartDate Datetime
DECLARE @dEndDate Datetime		 
	SELECT	@dStartDate = Convert(Datetime, NULLIF(@StartDate,'')),
		@dEndDate = Convert(Datetime, NULLIF(@EndDate,''))

select *
from (
--AM Block
	SELECT Owning_Company.name,location.Location,Vehicle_Class.Vehicle_Class_Name,	 convert(varchar,Calendar_Date, 111) Calendar_Date,
		'AM' as Block,
		AM_Availability as Availability
	FROM	Truck_Inventory
	Inner Join Vehicle_Class
		On Truck_Inventory.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location
		ON Truck_Inventory.Location_ID = Location.Location_ID
	INNER JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
	WHERE	
	
	--Location_ID = @iLocId
	(@LocId = '*' OR CONVERT(INT, @tmpLocID) = Truck_Inventory.Location_ID)
	AND
	(@paramCompanyID = '*' OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	--AND	Vehicle_Class_Code = @VehClassCode
	And (@VehClassCode = '*' OR Truck_Inventory.Vehicle_Class_Code = @VehClassCode)
	
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate

union
--PM Block
	SELECT Owning_Company.name,location.Location,Vehicle_Class.Vehicle_Class_Name,	 convert(varchar,Calendar_Date, 111) Calendar_Date,
		'PM' as Block,
		PM_Availability as Availability
	FROM	Truck_Inventory
	Inner Join Vehicle_Class
		On Truck_Inventory.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location
		ON Truck_Inventory.Location_ID = Location.Location_ID
	INNER JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
	WHERE	
	
	--Location_ID = @iLocId
	(@LocId = '*' OR CONVERT(INT, @tmpLocID) = Truck_Inventory.Location_ID)
	AND
	(@paramCompanyID = '*' OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	--AND	Vehicle_Class_Code = @VehClassCode
	And (@VehClassCode = '*' OR Truck_Inventory.Vehicle_Class_Code = @VehClassCode)
	
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate

union
--OV Block
	SELECT Owning_Company.name,location.Location,Vehicle_Class.Vehicle_Class_Name,	convert(varchar,Calendar_Date, 111) Calendar_Date,
		'OV' as Block,
		OV_Availability as Availability
	FROM	Truck_Inventory
	Inner Join Vehicle_Class
		On Truck_Inventory.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location
		ON Truck_Inventory.Location_ID = Location.Location_ID
	INNER JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
	WHERE	
	
	--Location_ID = @iLocId
	(@LocId = '*' OR CONVERT(INT, @tmpLocID) = Truck_Inventory.Location_ID)
	AND
	(@paramCompanyID = '*' OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	--AND	Vehicle_Class_Code = @VehClassCode
	And (@VehClassCode = '*' OR Truck_Inventory.Vehicle_Class_Code = @VehClassCode)
	
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate
) Truck
	ORDER BY  convert(datetime,Calendar_Date),name,location
	RETURN @@ROWCOUNT


GO
