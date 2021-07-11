USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateSelection]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Vehicle_Class
CREATE   PROCEDURE [dbo].[GetRateSelection]  --'a','20','2015-10-27 07:30','20','2015-10-30 07:30','Regular'
			@VehClassCode varchar(20),		
		    @PickupLoc varchar(30),		   
			@PickupDate varchar(20),
			@DropOffLocID varchar(15),
			@DropOffDate Varchar(20),
			@SelectionType Varchar(20)
						
AS

DECLARE	@dPickupDate datetime
DECLARE	@dDropOffDate datetime

SELECT	@dPickupDate =convert (datetime,@PickupDate)
SELECT	@dDropOffDate =convert (datetime,@DropOffDate)


-- the Following are for Time Block

DECLARE   @PickupTime as Varchar(5)
DECLARE   @DropTime as Varchar(5)

DECLARE   @PUTime as Varchar(5)
DECLARE   @DOTime as Varchar(5)
DECLARE   @OwningCompanyID as int

Select @PickupTime= dbo.GetTimePart(@dPickupDate)
Select @DropTime = dbo.GetTimePart (@dDropOffDate)

Select @OwningCompanyID = Owning_Company_id from Location where Location_ID=@PickupLoc
select @PUTime=dbo.GetBlockTime('PU',@PickupTime, @OwningCompanyID)
select @DOTime=dbo.GetBlockTime('DO',@DropTime, @OwningCompanyID)

 
--'Round Trip'
--'Around town Regular' 
Select Distinct VCRate.Rate_ID, VCRate.Rate_Level, VCRate.Selection_Type, VCRate.Vehicle_Class_Code,LOR_Max
From 
(
	SELECT      RateSelection.Vehicle_Class_Code, RateSelection.Rate_ID, RateSelection.Rate_Level, RateSelection.Selection_Type, 
	RateSelection.PU_DOW, RateSelection.DO_DOW,LOR_Max
	FROM          
					  (  SELECT -- top 100   
					  dbo.Rate_Selection.Pickup_Location_ID, dbo.Rate_Selection.Vehicle_Class_Code,  dbo.Rate_Selection.Selection_Type, 
						  dbo.Rate_Selection.Rate_ID, dbo.Rate_Selection.Rate_Level, 
						  dbo.Rate_Selection.Valid_From, dbo.Rate_Selection.Valid_To, 
						  (Case When PU_DOW_SUN=1 then '1' Else'' End)+
						  (Case When PU_DOW_MON=1 then '2' Else'' End)+
						  (Case When PU_DOW_TUE=1 then '3' Else'' End)+
						  (Case When PU_DOW_WED=1 then '4' Else'' End)+
						  (Case When PU_DOW_THU =1 then '5' Else'' End)+
						  (Case When PU_DOW_FRI =1 then '6' Else'' End)+
						  (Case When PU_DOW_SAT =1 then '7' Else'' End)   as PU_DOW,
						  
						  (Case When DO_DOW_SUN=1 then '1' Else'' End)+
						  (Case When DO_DOW_MON=1 then '2' Else'' End)+
						  (Case When DO_DOW_TUE=1 then '3' Else'' End)+
						  (Case When DO_DOW_WED=1 then '4' Else'' End)+
						  (Case When DO_DOW_THU =1 then '5' Else'' End)+
						  (Case When DO_DOW_FRI =1 then '6' Else'' End)+
						  (Case When DO_DOW_SAT =1 then '7' Else'' End)   as DO_DOW,
						  LOR_Min, LOR_Max
						FROM         dbo.Rate_Selection 
						--order by  LOR_Max
 ) RateSelection
 INNER JOIN  dbo.Rate_Vehicle_Class RateVC 
	 ON RateSelection.Rate_ID = RateVC.Rate_ID 
	 AND RateSelection.Vehicle_Class_Code = RateVC.Vehicle_Class_Code
Where
	RateSelection.Pickup_Location_ID = @PickupLoc
	And @dPickupDate Between RateSelection.Valid_from and isnull(RateSelection.Valid_To, '2078-12-31')
	And PU_DOW like '%'+ convert(char(1),DatePart(dw,@dPickupDate)) + '%'
	And DO_DOW like '%'+ convert(char(1),DatePart(dw,@dDropOffDate)) + '%'	
	And  (ceiling(datediff(mi, @dPickupDate, @dDropOffDate)/1440.00)between LOR_Min And LOR_Max)	
    And (RateVC.Termination_Date>getdate() or RateVC.Termination_Date is null)    
    And RateSelection.Vehicle_Class_Code=@VehClassCode
    And RateSelection.Selection_Type=@SelectionType
) VCRate
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

On VCRate.Rate_ID=		LocationRate.Rate_ID
Inner Join (SELECT   Rate_ID, Effective_Date, 
			Termination_Date, Rate_Level
			From dbo.Rate_Level where Termination_Date>getdate()) RL
On VCRate.Rate_ID = RL.Rate_ID
 

Union

Select Distinct VCRate.Rate_ID, VCRate.Rate_Level, VCRate.Selection_Type, VCRate.Vehicle_Class_Code, LOR_Max
From 
(
SELECT      RateSelection.Vehicle_Class_Code, RateSelection.Rate_ID, RateSelection.Rate_Level, RateSelection.Selection_Type, 
RateSelection.PU_DOW, RateSelection.DO_DOW, LOR_Max
FROM          
                  (  SELECT     dbo.Rate_Selection.Pickup_Location_ID, dbo.Rate_Selection.Vehicle_Class_Code,   dbo.Rate_Selection.Selection_Type, 
                      PUBlock.Block_Time AS PUTime, DOBlock.Block_Time AS DOTime, dbo.Rate_Selection.Rate_ID, dbo.Rate_Selection.Rate_Level, 
                      dbo.Rate_Selection.Valid_From, dbo.Rate_Selection.Valid_To, 
                      (Case When PU_DOW_SUN=1 then '1' Else'' End)+
					  (Case When PU_DOW_MON=1 then '2' Else'' End)+
					  (Case When PU_DOW_TUE=1 then '3' Else'' End)+
					  (Case When PU_DOW_WED=1 then '4' Else'' End)+
					  (Case When PU_DOW_THU =1 then '5' Else'' End)+
					  (Case When PU_DOW_FRI =1 then '6' Else'' End)+
					  (Case When PU_DOW_SAT =1 then '7' Else'' End)   as PU_DOW,
					  
					  (Case When DO_DOW_SUN=1 then '1' Else'' End)+
					  (Case When DO_DOW_MON=1 then '2' Else'' End)+
					  (Case When DO_DOW_TUE=1 then '3' Else'' End)+
					  (Case When DO_DOW_WED=1 then '4' Else'' End)+
					  (Case When DO_DOW_THU =1 then '5' Else'' End)+
					  (Case When DO_DOW_FRI =1 then '6' Else'' End)+
					  (Case When DO_DOW_SAT =1 then '7' Else'' End)   as DO_DOW,
					  LOR_Min, LOR_Max
						  
					FROM         dbo.Rate_Selection  INNER JOIN
											  (SELECT     Block_Name, Block_Type, Block_Time
												FROM          dbo.Truck_Time_Block
												WHERE      (Block_Type = 'PU' 
												 and Owning_Company_id =@OwningCompanyID
												)) AS PUBlock ON dbo.Rate_Selection.Pickup_Time_Block = PUBlock.Block_Name 
												Left JOIN
											  (SELECT     Block_Name, Block_Type, Block_Time
												FROM          dbo.Truck_Time_Block 
												WHERE      (Block_Type = 'DO'
												 and Owning_Company_id =@OwningCompanyID
												)) AS DOBlock ON dbo.Rate_Selection.Dropoff_Time_Block = DOBlock.Block_Name
					
					) RateSelection


 INNER JOIN
          dbo.Rate_Vehicle_Class RateVC ON RateSelection.Rate_ID = RateVC.Rate_ID AND RateSelection.Vehicle_Class_Code = RateVC.Vehicle_Class_Code
Where
	RateSelection.Pickup_Location_ID = @PickupLoc
	And @dPickupDate Between RateSelection.Valid_from and isnull(RateSelection.Valid_To, '2078-12-31')
	And PU_DOW like '%'+ convert(char(1),DatePart(dw,@dPickupDate)) + '%'
	And DO_DOW like '%'+ convert(char(1),DatePart(dw,@dDropOffDate)) + '%'	
	And  (ceiling(datediff(mi, @dPickupDate, @dDropOffDate)/1440.00)between LOR_Min And LOR_Max)		
	And ( RateSelection.PUTime =@PUTime	And  (RateSelection.DOTime=@DOTime or  RateSelection.DOTime is null or RateSelection.DOTime=''))
    And (RateVC.Termination_Date>getdate() or RateVC.Termination_Date is null)    
    And RateSelection.Vehicle_Class_Code=@VehClassCode
    And RateSelection.Selection_Type=@SelectionType
) VCRate
Inner Join 
(
SELECT     LocationSet.Rate_ID
FROM         dbo.Rate_Location_Set LocationSet INNER JOIN
                      dbo.Rate_Location_Set_Member LocationSetMember ON LocationSet.Rate_ID = LocationSetMember.Rate_ID 

AND LocationSet.Rate_Location_Set_ID = LocationSetMember.Rate_Location_Set_ID
Where LocationSet.Termination_Date>getdate() And LocationSetMember.Termination_Date>getdate() And LocationSet.Allow_All_Auth_Drop_Off_Locs = 1
		   And LocationSetMember.Location_ID=Convert(smallint,@PickupLoc)
	
Union
SELECT     LocationSet.Rate_ID
FROM         dbo.Rate_Location_Set LocationSet INNER JOIN
                      dbo.Rate_Location_Set_Member LocationSetMember ON LocationSet.Rate_ID = LocationSetMember.Rate_ID 

AND 
                      LocationSet.Rate_Location_Set_ID = LocationSetMember.Rate_Location_Set_ID INNER JOIN
                      dbo.Rate_Drop_Off_Location DropOffLocation ON LocationSet.Rate_ID = DropOffLocation.Rate_ID                       
                      AND LocationSet.Rate_Location_Set_ID = DropOffLocation.Rate_Location_Set_ID
Where LocationSet.Termination_Date>getdate() And LocationSetMember.Termination_Date>getdate() 
		And LocationSetMember.Location_ID=Convert(smallint,@PickupLoc)
		And DropOffLocation.Location_ID=Convert(int,@DropOffLocID)
		And DropOffLocation.Termination_Date>getdate()
) LocationRate

On VCRate.Rate_ID = LocationRate.Rate_ID
Inner Join (SELECT   Rate_ID, Effective_Date, 
			Termination_Date, Rate_Level
			From dbo.Rate_Level where Termination_Date>getdate()) RL
On VCRate.Rate_ID = RL.Rate_ID
Order by  LOR_Max
GO
