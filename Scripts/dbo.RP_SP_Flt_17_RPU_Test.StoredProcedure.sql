USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_17_RPU_Test]    Script Date: 2021-07-10 1:50:50 PM ******/
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
create PROCEDURE [dbo].[RP_SP_Flt_17_RPU_Test]    --'*','*', '01 Dec 2013', '31 Dec 2013'
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


 

 SELECT
	contract_number, 
	Pick_Up_On,
	Check_In,
	Rental_Days, 
	Vehicle_Type_ID, 
	Vehicle_Class_Code, 
	
	(Case 
		When Pick_Up_On >= @startDate and Check_In < @endDate+1	
		Then datediff(mi,Pick_Up_On,Check_In)/ 1440.00
	--2		MB	CO	ME	CI
		When Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In
		Then datediff(mi,Pick_Up_On,@endDate+1)/ 1440.00
	--3		CO	MB	CI	ME		 
		When @startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1
				 
		Then datediff(mi,@startDate,Check_In)/ 1440.00
	--4		CO	MB	ME	CI
		When @startDate>=Pick_Up_On and @endDate+1<=Check_In 
		Then  datediff(mi,@startDate,@endDate+1)/ 1440.00
	End) DaysCounter,	
	RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 				
	TimeCharge/Rental_Days as DailyTime, 
	Kms/Rental_Days as DailyKMs,  
	LDW/Rental_Days as DailyLDW , 
	PAI/Rental_Days as DailyPAI, 
	PEC/Rental_Days as DailyPEC, 
	MovingAids/Rental_Days as DailyMovingAids, 
    MovingSupply/Rental_Days as DailyMovingSupply,
	VLF/Rental_Days as DailyVLF, 
	LRF/Rental_Days as DailyLRF,
	DropCharge/Rental_Days as DailyDropCharge,
	Additional_Driver_Charge/Rental_Days as DailyAddDriver,  
	Driver_Under_Age/Rental_Days as DailyYoungDriver,
	BuyDown/Rental_Days as DailyBuyDown ,
	gps/Rental_Days as DailyGPS, 
	fpo/Rental_Days as DailyFPO ,
	ELI/Rental_Days as DailyELI, 
	CrossBoardSurcharge/Rental_Days as DailyCrossBoardSurcharge,
	SnowTires/Rental_Days as DailySnowTires, 
	ERF/Rental_Days as DailyERF,
	BabySeats/Rental_Days as DailyBabySeats,
	
	TimeCharge, 
	Kms, 
	LDW, 
	PAI, 
	PEC , 
	MovingAids , 
    MovingSupply ,
	VLF , 
	LRF ,
	DropCharge ,
	Additional_Driver_Charge ,  
	Driver_Under_Age ,
	BuyDown ,
	gps , 
	fpo  ,
	ELI , 
	CrossBoardSurcharge ,
	SnowTires , 
	ERF ,
	BabySeats ,
	
	DisplayOrder
FROM       dbo.RP_FLT_17_Vehicle_Revenue_Main

 

WHERE   ( @paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID) 	
	AND
	(
		(Pick_Up_On >= @startDate and Check_In < @endDate+1	)  
		Or
		(Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In)
		Or
		(@startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1)
		Or
		(@startDate>=Pick_Up_On and @endDate+1<=Check_In)
	)
--group by  contract_number, Vehicle_Type_ID,Vehicle_Class_Code, Vehicle_Class_Name, DisplayOrder
GO
