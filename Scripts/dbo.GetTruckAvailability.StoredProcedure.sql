USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTruckAvailability]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--******************************************************************************************************
--*** Created By Roy He
--*** Date: 2003-08-20
--*** Called by Online reservation
--*** Iterate through all the time blocks during the pickup date and drop off date,and get the availibility
--*** (STBLK>=PUDT And STBLK<DPDT) or (EDBLK > PUDT and EDBLK <=DPDT) OR (STBLK<=PUDT AND EDBLK>=DPDT) 
--******************************************************************************************************

create PROCEDURE [dbo].[GetTruckAvailability]  --16 , 'M', '2003-09-01', '2003-09-02 8:00'

       @PickupLocationID as varchar(20),
       @VehClassCode Varchar(1),
       @PickupDate varchar(30),
       @DropOffDate varchar(30)

as

DECLARE @iLocId SmallInt
DECLARE @StartDate Datetime
DECLARE @EndDate Datetime
DECLARE @BlockStartTime Datetime
DECLARE @BlockEndTime Datetime
DECLARE @VehcileType varchar(18)

SELECT 	@iLocId = Convert(SmallInt, NULLIF(@PickupLocationID,'')),
	@VehClassCode = NULLIF(@VehClassCode,''),
	@StartDate=CONVERT(DATETIME, @PickupDate ),
	@EndDate=CONVERT(DATETIME, @DropOffDate)

select @VehcileType=Vehicle_type_ID from Vehicle_Class where Vehicle_Class_Code=@VehClassCode

if @VehcileType='Car' 
	Select	AvailQty=1,TimeBockName='All',BlockStartTime= '1999-01-01 12:00:00.00 AM',BlockEndTime='2078-01-01 23:59:59.00'
else

begin
 
	SELECT     
	--dbo.Truck_Inventory.Location_ID, 
	--dbo.Truck_Inventory.Vehicle_Class_Code, 
	--dbo.Truck_Inventory.Calendar_Date, 
	
	AvailQty=(
		case 
			when dbo.TimeBlock.TimeBlockName='AM' then dbo.Truck_Inventory.AM_Availability		
	  		when dbo.TimeBlock.TimeBlockName='PM' then dbo.Truck_Inventory.PM_Availability
			when dbo.TimeBlock.TimeBlockName='OV' then dbo.Truck_Inventory.OV_Availability
		end) ,
	
	TimeBlockName, 
	BlockStartTime= dbo.Truck_Inventory.Calendar_Date + ' '+dbo.TimeBlock.StartTime --as BlockStartTime 
	,BlockEndTime=(Case 
		when dbo.TimeBlock.TimeBlockName='OV' then (dbo.Truck_Inventory.Calendar_Date+1) + ' '+dbo.TimeBlock.EndTime
		else (dbo.Truck_Inventory.Calendar_Date) + ' '+dbo.TimeBlock.EndTime
	end
	  )  --as BlockEndTime
	
	FROM  dbo.Truck_Inventory, dbo.TimeBlock
	Where dbo.Truck_Inventory.Location_ID=@iLocId and dbo.Truck_Inventory.Vehicle_Class_Code=@VehClassCode and 
	(
	   ( CONVERT(DATETIME,dbo.Truck_Inventory.Calendar_Date + ' '+dbo.TimeBlock.StartTime) >=@StartDate and CONVERT(DATETIME,dbo.Truck_Inventory.Calendar_Date + ' '+dbo.TimeBlock.StartTime)< @EndDate)
	   or 
	   ( 
	
	      CONVERT(DATETIME,
		(Case 
			when dbo.TimeBlock.TimeBlockName='OV' then (dbo.Truck_Inventory.Calendar_Date+1) + ' '+dbo.TimeBlock.EndTime
			else (dbo.Truck_Inventory.Calendar_Date) + ' '+dbo.TimeBlock.EndTime
		end  )
		)
	       >@StartDate and 
	
		CONVERT(DATETIME,
		(Case 
			when dbo.TimeBlock.TimeBlockName='OV' then (dbo.Truck_Inventory.Calendar_Date+1) + ' '+dbo.TimeBlock.EndTime
			else (dbo.Truck_Inventory.Calendar_Date) + ' '+dbo.TimeBlock.EndTime
			end  )
		)
		<= @EndDate
	   )
	   or 
	   (
	    	CONVERT(DATETIME,dbo.Truck_Inventory.Calendar_Date + ' '+dbo.TimeBlock.StartTime)<=@StartDate and 
	
	   	CONVERT(DATETIME,
		(Case 
			when dbo.TimeBlock.TimeBlockName='OV' then (dbo.Truck_Inventory.Calendar_Date+1) + ' '+dbo.TimeBlock.EndTime
			else (dbo.Truck_Inventory.Calendar_Date) + ' '+dbo.TimeBlock.EndTime
		end  )
		)> 
	
		@EndDate
	     )
	 )
	
end
GO
