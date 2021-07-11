USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_14_Vehicle_Revenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






















/*
PROCEDURE NAME: RP_SP_Acc_15_Revenue_By_Vehicle_Class
PURPOSE: Select all information needed for Revenue By VC
AUTHOR:	Roy He
DATE CREATED: 2005/05/16
USED BY:  Revenue By Vehicle Class
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_14_Vehicle_Revenue]   --  '*', '*', '*','*', '01 feb 2013', '15 feb 2013'
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*',
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000'
)
AS




DECLARE 	@startDate datetime,
		@endDate datetime


-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '00:00:00 ' + @paramEndDate)+1	





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


--if @intHubID<>9 AND @intHubID<>14




SELECT  --   RBR_Date, 
	Vehicle_Type_ID as Vehicle_Type,
	Contract_number,
	unit_number, 
	Vehicle_Type_ID, 
	Vehicle_Class_Code, 
	--DisplayOrder,
	--Convert(Varchar(2),DisplayOrder+100) + '-' + Vehicle_Class_Name Vehicle_Class_Name, 
	
	RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 
				
	model_name, 
	model_year, 
	hub_id, 
	Hub_Name, 
    Location_id, 
	Location_Name, 
	--DaysInservice,
	sum(TimeCharge) as Time, 
	sum(Kms) as KMs,  
	sum(LDW) as LDW , 
	sum(PAI) as PAI, 
	sum(PEC) as PEC, 
	sum(MovingAids) as MovingAids, 
    sum(MovingSupply) as MovingSupply,
	Sum(VLF) as VLF, 
	sum(LRF) as LRF,
	sum(DropCharge) as DropCharge,
	sum(Additional_Driver_Charge) as AddDriver,  
	sum(Driver_Under_Age) as YoungDriver,
	sum(BuyDown) as BuyDown ,
	sum(gps) as GPS, 
	sum(fpo) as FPO ,
	sum(ELI) as ELI, 
	sum(CrossBoardSurcharge) as CrossBoardSurcharge,
	sum(SnowTires) as SnowTires, 
	sum(ERF) as ERF,
	DisplayOrder
FROM       dbo.RP_FLT_14_Vehicle_Revenue_Main

WHERE   ( @paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) =Location_id)
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = Hub_ID)
	AND
	(RBR_Date>=@startDate and RBR_Date<@endDate) --and MovingAids<>0
	
	 
        --(@paramHubID = "*" or  Location.Hub_ID<>9)
	--AND
	--Vehicle.Deleted = 0
group by Contract_number, unit_number, Vehicle_Type_ID, Vehicle_Class_Code, Vehicle_Class_Name, model_name, model_year, hub_id, Hub_Name, 
          Location_id, Location_Name, DisplayOrder
          
Order by   DisplayOrder,Location_Name,Vehicle_Type_ID,Vehicle_Class_Code        
          










GO
