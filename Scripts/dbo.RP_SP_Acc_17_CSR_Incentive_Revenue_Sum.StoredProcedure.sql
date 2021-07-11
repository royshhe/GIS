USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CSR_Incentive_Revenue_Sum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select sum(Upgrade+Up_Sell)  from RP_ACC_17_CSR_Incremental_Incentive_Revenue where rbr_date='2008-07-31'
--select sum(Upgrade)+sum(Up_Sell)  from RP_ACC_17_CSR_Incremental_Incentive_Revenue where rbr_date='2008-07-31'

CREATE PROCEDURE [dbo].[RP_SP_Acc_17_CSR_Incentive_Revenue_Sum] -- '2008-01-01','2008-12-31'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
    @paramEndBusDate varchar(20) = '22 Apr 2001'
	
)
AS
--convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	




SELECT 	Revenue.Location, 
	Month(Revenue.RBR_Date) as RevenueMonth,
	
	Sum(Revenue.Contract_In) Contract_In, 
   	Sum(Revenue.Rental_Days), 
	Sum(Revenue.Upgrade+Revenue.Up_Sell +Revenue.Upgrade_Adj+Revenue.Up_Sell_Adj) As Upgrade, 
	Sum(Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj) as All_Level_LDW, 
	Sum(Revenue.PAI+Revenue.PAI_Adj) As PAI, 
	Sum(Revenue.PEC+Revenue.PEC_Adj) As PEC, 
    Sum(Revenue.ELI+Revenue.ELI_Adj) As ELI,
    Sum(Revenue.GPS +Revenue.GPS_Adj) As GPS, 
	Sum(Revenue.Additional_Driver_Charge+Revenue.Additional_Driver_Charge_Adj) As Additional_Driver_Charge, 
    Sum(Revenue.All_Seats+Revenue.All_Seats_Adj) As All_Seats, 
	Sum(Revenue.Driver_Under_Age+Revenue.Driver_Under_Age_Adj) As Driver_Under_Age, 
	Sum(Revenue.Ski_Rack+Revenue.Ski_Rack_Adj) As Ski_Rack, 
	Sum(Revenue.Seat_Storage +Revenue.Seat_Storage_Adj) As Seat_Storage,
	Sum(Revenue.Our_Of_Area +Revenue.Our_Of_Area_Adj) As Our_Of_Area,
	Sum(Revenue.All_Dolly +Revenue.All_Dolly_Adj) As All_Dolly, 
	Sum(Revenue.All_Gates+Revenue.All_Gates_Adj) As  All_Gates, 
	Sum(Revenue.Blanket+Revenue.Blanket_Adj) as Blanket, 

	Sum(Revenue.Upgrade+Revenue.Up_Sell+
	Revenue.All_Level_LDW+
	Revenue.PAI+ 
	Revenue.PEC+ 
   	Revenue.ELI+ 
	Revenue.GPS+ 
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+ 
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket	
+
	Revenue.Upgrade_Adj+Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj
)
as SalesItemRevenue,

	


   Convert(decimal (6, 2),
			SUM(Revenue.Upgrade+Revenue.Up_Sell+
			Revenue.All_Level_LDW+
			Revenue.PAI+ 
			Revenue.PEC+ 
			Revenue.ELI+ 
			Revenue.GPS+  
			Revenue.Additional_Driver_Charge+ 
			Revenue.All_Seats+ 
			Revenue.Driver_Under_Age+ 
			Revenue.Ski_Rack+
			Revenue.Seat_Storage+
			Revenue.Our_Of_Area+ 
			Revenue.All_Dolly+ 
			Revenue.All_Gates+ 
			Revenue.Blanket
		+
			Revenue.Upgrade_Adj+Revenue.Up_Sell_Adj+
			Revenue.All_Level_LDW_Adj+
			Revenue.PAI_Adj+ 
			Revenue.PEC_Adj+ 
   			Revenue.ELI_Adj+ 
			Revenue.GPS_Adj+ 
			Revenue.Additional_Driver_Charge_Adj+ 
			Revenue.All_Seats_Adj+ 
			Revenue.Driver_Under_Age_Adj+ 
			Revenue.Ski_Rack_Adj+ 
			Revenue.Seat_Storage_Adj+
			Revenue.Our_Of_Area_Adj+
			Revenue.All_Dolly_Adj+ 
			Revenue.All_Gates_Adj+ 
			Revenue.Blanket_Adj

			)/
			(Case When SUM(Revenue.Rental_Days)>0 then SUM(Revenue.Rental_Days) Else 1 End)
	  )
       as SalesItemDDA,


    Sum( Revenue.Walkup_Rental_Days) as Walkup_Rental_Days, 
	Sum(Revenue.Walkup_TnM) as Walkup_TnM, 
        
	Convert(decimal (6, 2),
	        SUM(Walkup_TnM)/
			(Case When SUM(Walkup_Rental_Days)>0 Then SUM(Walkup_Rental_Days) Else 1 End)
		
		)
	 as WalkUpDDA,
	
     SUM(Walkup_Count) as Walkup_Count,
	
    SUM(Revenue.FPO_Contract_Count) FPO_Contract_Count, 
    SUM(Revenue.FPOCount+Revenue.FPOCount_Adj)  as FPOCount,

    Convert(decimal(5,2),
		Round(
			 (
					 
					Convert(decimal (6, 2),
						SUM(Revenue.FPOCount+Revenue.FPOCount_Adj )
					)
			  		/
			  		Convert(decimal (6, 2),
				  		(Case When SUM(Revenue.FPO_Contract_Count)>0 Then SUM(Revenue.FPO_Contract_Count) Else 1 End)
					 )
			   
			 )*100
		,0)
       )
		AS  FPOMarketSaturation,


	Convert(decimal (5, 2),
	        (
		SUM (Revenue.Upgrade++Revenue.Upgrade_Adj)/(Case When SUM(Revenue.Rental_Days) >0 Then SUM(Revenue.Rental_Days) Else 1 End)
		)
	)
	 as UpgradeDDA

FROM         dbo.RP_ACC_17_CSR_Incremental_Incentive_Revenue Revenue 
where 
(Revenue.RBR_Date BETWEEN @startBusDate and @endBusDate) 
Group by 	Revenue.Location, Month(Revenue.RBR_Date)
Order by Revenue.Location, Month(Revenue.RBR_Date)













GO
