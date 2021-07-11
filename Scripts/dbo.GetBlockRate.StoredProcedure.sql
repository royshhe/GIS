USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetBlockRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Vehicle_Class
create  PROCEDURE [dbo].[GetBlockRate]      --'26','m','2011-12-17 07:30','26','2011-12-17 11:30'
		    @PickupLoc varchar(30),
		    @VehClassCode varchar(20),		
			@PickupDate varchar(20),
			@DropOffLocID varchar(15),
			@DropOffDate Varchar(20)
			
			
AS


DECLARE	@dPickup datetime
DECLARE	@dDropOff datetime
DECLARE	@dPickupDate datetime
DECLARE	@dDropOffDate datetime

DECLARE   @PickupTime as Varchar(5)
DECLARE   @DropTime as Varchar(5)

DECLARE   @PUTime as Varchar(5)
DECLARE   @DOTime as Varchar(5)
DECLARE   @OwningCompanyID as int

-- truncate time portion from pick up date/time
SELECT	@dPickup =convert (datetime,@PickupDate)
SELECT	@dDropOff =convert (datetime,@DropOffDate)

Select @PickupTime= dbo.GetTimePart(@dPickup)
Select @DropTime = dbo.GetTimePart (@dDropOff)

Select @OwningCompanyID = Owning_Company_id from Location where Location_ID=@PickupLoc
select @PUTime=dbo.GetBlockTime('PU',@PickupTime, @OwningCompanyID)
select @DOTime=dbo.GetBlockTime('DO',@DropTime, @OwningCompanyID)

Select @dPickupDate=Convert(Varchar, @dPickup,106) 
Select @dDropOffDate=Convert(Varchar, @dDropOff,106) 
  
--'Round Trip'
--'Around Town'
Select Distinct TruckResVCRate.Rate_ID, TruckResVCRate.Rate_Level, 'Block' Rate_Selection_Type, TruckResVCRate.Vehicle_Class_Code
From 
(
SELECT      TruckResRate.Vehicle_Class_Code, TruckResRate.Rate_ID, TruckResRate.Rate_Level, --TruckResRate.Trip_Type,
TruckResRate.Day_Of_Week 
FROM          
                  (  SELECT     dbo.Truck_Block_Rate_Selection.Pickup_Location_ID, dbo.Truck_Block_Rate_Selection.Vehicle_Class_Code,-- dbo.Truck_Block_Rate_Selection.Trip_Type, 
                      PUBlock.Block_Time AS PUTime, DOBlock.Block_Time AS DOTime, dbo.Truck_Block_Rate_Selection.Rate_ID, dbo.Truck_Block_Rate_Selection.Rate_Level, 
                      dbo.Truck_Block_Rate_Selection.Valid_From, dbo.Truck_Block_Rate_Selection.Valid_To, 
                      (Case When DOW_SUN=1 then '1' Else'' End)+
					  (Case When DOW_MON=1 then '2' Else'' End)+
					  (Case When DOW_TUE=1 then '3' Else'' End)+
					  (Case When DOW_WED=1 then '4' Else'' End)+
					  (Case When DOW_THU =1 then '5' Else'' End)+
					  (Case When DOW_FRI =1 then '6' Else'' End)+
					  (Case When DOW_SAT =1 then '7' Else'' End)   as Day_Of_Week 
					FROM         dbo.Truck_Block_Rate_Selection INNER JOIN
											  (SELECT     Block_Name, Block_Type, Block_Time
												FROM          dbo.Truck_Time_Block
												WHERE      (Block_Type = 'PU' 
												 and Owning_Company_id =@OwningCompanyID
												)) AS PUBlock ON dbo.Truck_Block_Rate_Selection.Pickup_Time_Block = PUBlock.Block_Name 
												Left JOIN
											  (SELECT     Block_Name, Block_Type, Block_Time
												FROM          dbo.Truck_Time_Block 
												WHERE      (Block_Type = 'DO'
												 and Owning_Company_id =@OwningCompanyID
												)) AS DOBlock ON dbo.Truck_Block_Rate_Selection.Dropoff_Time_Block = DOBlock.Block_Name
					--WHERE     (dbo.Truck_Block_Rate_Selection.Termination_Date > GETDATE() or dbo.Truck_Block_Rate_Selection.Termination_Date is Null) 
					) TruckResRate


 INNER JOIN
                      dbo.Rate_Vehicle_Class RateVC ON TruckResRate.Rate_ID = RateVC.Rate_ID AND TruckResRate.Vehicle_Class_Code = RateVC.Vehicle_Class_Code
Where
	TruckResRate.Pickup_Location_ID = @PickupLoc
	And @dPickupDate Between TruckResRate.Valid_from and isnull(TruckResRate.Valid_To, '2078-12-31')
	And  Day_Of_Week like '%'+ convert(char(1),DatePart(dw,@dPickupDate)) + '%'
	--And (( TruckResRate.PUTime =@PickupTime	And  (TruckResRate.DOTime=@DropTime or  TruckResRate.DOTime is null or TruckResRate.DOTime='') and @TripType='Around Town') or (@TripType='Round Trip'))
	And ( TruckResRate.PUTime =@PUTime	And  (TruckResRate.DOTime=@DOTime or  TruckResRate.DOTime is null or TruckResRate.DOTime=''))
    And (RateVC.Termination_Date>getdate() or RateVC.Termination_Date is null)
    --And TruckResRate.Trip_Type=@TripType
    And TruckResRate.Vehicle_Class_Code=@VehClassCode
) TruckResVCRate
Inner Join 
(
SELECT     LocationSet.Rate_ID
FROM         dbo.Rate_Location_Set LocationSet INNER JOIN
                      dbo.Rate_Location_Set_Member LocationSetMember ON LocationSet.Rate_ID = LocationSetMember.Rate_ID 
--AND 
--                      LocationSet.Effective_Date = LocationSetMember.Effective_Date 
AND LocationSet.Rate_Location_Set_ID = LocationSetMember.Rate_Location_Set_ID
Where LocationSet.Termination_Date>getdate() And LocationSetMember.Termination_Date>getdate() And LocationSet.Allow_All_Auth_Drop_Off_Locs = 1
		   And LocationSetMember.Location_ID=Convert(smallint,@PickupLoc)
	
Union
SELECT     LocationSet.Rate_ID
FROM         dbo.Rate_Location_Set LocationSet INNER JOIN
                      dbo.Rate_Location_Set_Member LocationSetMember ON LocationSet.Rate_ID = LocationSetMember.Rate_ID 
--AND 
--                      LocationSet.Effective_Date = LocationSetMember.Effective_Date 
AND 
                      LocationSet.Rate_Location_Set_ID = LocationSetMember.Rate_Location_Set_ID INNER JOIN
                      dbo.Rate_Drop_Off_Location DropOffLocation ON LocationSet.Rate_ID = DropOffLocation.Rate_ID 
                      --AND LocationSet.Effective_Date = DropOffLocation.Effective_Date 
                      AND LocationSet.Rate_Location_Set_ID = DropOffLocation.Rate_Location_Set_ID
Where LocationSet.Termination_Date>getdate() And LocationSetMember.Termination_Date>getdate() --And LocationSet.Allow_All_Auth_Drop_Off_Locs = 1
		And LocationSetMember.Location_ID=Convert(smallint,@PickupLoc)
		And DropOffLocation.Location_ID=Convert(int,@DropOffLocID)
		And DropOffLocation.Termination_Date>getdate()
) LocationRate

On TruckResVCRate.Rate_ID = LocationRate.Rate_ID
Inner Join (SELECT   Rate_ID, Effective_Date, 
			Termination_Date, Rate_Level
			From dbo.Rate_Level where Termination_Date>getdate()) RL
On TruckResVCRate.Rate_ID = RL.Rate_ID
GO
