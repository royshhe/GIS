USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Sls]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Sls
PURPOSE: Count number of separate accessory sales made during an hour block on a day

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_3_Daily_Contract_Tran_Stat_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Sls]
AS
SELECT 
	'Sls' AS Transaction_Type,
	'Truck' AS Vehicle_Type_ID,
	Sales_Accessory_Sale_Contract.Sold_At_Location_ID AS Location_ID, 
	Location.Location AS Location_Name,
	CONVERT(datetime, CONVERT(varchar(12), Sales_Accessory_Sale_Contract.Sales_Date_Time, 112))  AS Transaction_Date,	-- date accessory is sold
	DATEPART(hh, Sales_Accessory_Sale_Contract.Sales_Date_Time)  AS Transaction_Hour,	-- hour of the day accessory is sold
	Count(Sales_Accessory_Sale_Contract.Sales_Contract_Number) AS Cnt

FROM 	Sales_Accessory_Sale_Contract WITH(NOLOCK)
    	INNER 
	JOIN
    	Location 
		ON Sales_Accessory_Sale_Contract.Sold_At_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 -- Rental Locations
		AND Sales_Accessory_Sale_Contract.Refunded_Contract_No IS NULL
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 	

GROUP BY

	Sales_Accessory_Sale_Contract.Sold_At_Location_ID, 
	Location.Location,
	CONVERT(datetime, CONVERT(varchar(12), Sales_Accessory_Sale_Contract.Sales_Date_Time, 112)),
	DATEPART(hh, Sales_Accessory_Sale_Contract.Sales_Date_Time)  
























GO
