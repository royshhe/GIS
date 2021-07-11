USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCSRIncentiveAdj]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetCSRIncentiveAdj] --'2009-03-01', '2009-03-31'
@RBRStartDate Datetime,
@RBRStartEnd Datetime
--@LocID Int
as


SELECT     RBR_date, Location, Vehicle_Type_ID, CSR_Name, Upgrade_Adj, Up_Sell_Adj, All_Level_LDW_Adj, PAI_Adj, PEC_Adj, ELI_Adj, GPS_Adj, 
                      Additional_Driver_Charge_Adj, All_Seats_Adj, Driver_Under_Age_Adj, Ski_Rack_Adj, Seat_Storage_Adj, Our_Of_Area_Adj, All_Dolly_Adj, All_Gates_Adj, Blanket_Adj, 
                      FPOCount_Adj
FROM         dbo.RP_ACC_17_CSR_Incremental_Incentive_Revenue
WHERE     (RBR_date BETWEEN @RBRStartDate AND @RBRStartEnd) --And Location_id=@LocID
GO
