USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_17_RPU]    Script Date: 2021-07-10 1:50:50 PM ******/
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
CREATE PROCEDURE [dbo].[RP_SP_Flt_17_RPU]   --'*','*', '01 Mar 2015', '31 Mar 2015'
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',	 
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000'
)
AS




DECLARE 	@startDate datetime,
		@endDate datetime


-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '00:00:00 ' + @paramEndDate) 





-- fix upgrading problem (SQL7->SQL2000)


--if @intHubID<>9 AND @intHubID<>14


 Select Revenue.*,VU.NumberOfUnit from  

(SELECT  --   RBR_Date, 
	--Vehicle_Type_ID as Vehicle_Type,
	--Contract_number,
	--unit_number, 
	Vehicle_Type_ID, 
	Vehicle_Class_Code, 
	--DisplayOrder,
	--Convert(Varchar(2),DisplayOrder+100) + '-' + Vehicle_Class_Name Vehicle_Class_Name, 
	
	RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 
				
	--model_name, 
	--model_year, 

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
	sum(BabySeats) as BabySeats,
	
	DisplayOrder
FROM       svbvm007.dbo.RP_FLT_14_Vehicle_Revenue_Main

WHERE   ( @paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID) 	
	AND
	(RBR_Date>=@startDate and RBR_Date<=@endDate)  
group by   Vehicle_Type_ID, Vehicle_Class_Code, Vehicle_Class_Name, DisplayOrder
          
) Revenue
 
Left Join 
(SELECT 
		Vehicle_Class_Code, 
		Round((sum(Rentable)+sum(Not_Rentable)+sum(Rented))/(Round(datediff(d, @startDate, @endDate),2)+1.00),2) NumberOfUnit  
	FROM  RP_Flt_15_Vehicle_Utilization
	Where
		( @paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
		AND
 		(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID)
		
		AND
		-- RP_date has time and is on day behind
		(RP_Date>=@startDate+1 and RP_Date<@endDate+2) 
		Group by Vehicle_Class_Code 
)  VU

On   Revenue.Vehicle_Class_Code =  VU.Vehicle_Class_Code
Order by   Revenue.DisplayOrder, Revenue.Vehicle_Type_ID,Revenue.Vehicle_Class_Code
GO
