USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_1_Credit_Card_Balancing_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_CCI_1_Credit_Card_Balancing_Main
PURPOSE: Select all the information needed for main Credit Card Balancing Report.
	
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY: Credit Card Balancing Report (Main)
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/17	Add a column for a new group in report in order for 
				drilling down the credit card transaction details on a new page
*/

CREATE PROCEDURE [dbo].[RP_SP_CCI_1_Credit_Card_Balancing_Main]
(
	@paramBusDate varchar(20) = '22 Apr 1999'
)

AS

-- convert strings to datetime

DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)

SELECT	
	1 AS Grouping,
	Owning_Company.Name AS Company_Name,
	Location.Location AS Location_Name,
	Terminal.Terminal_ID,
    	Terminal_Daily_Total.RBR_Date,
	ISNULL(Credit_Card_Type.Credit_Card_Type, '*** Undefined ***') AS Credit_Card_Name,
    	Terminal_Daily_Total.Eigen_Purchase_Amount,
    	Terminal_Daily_Total.Eigen_Purchase_Count,
    	Terminal_Daily_Total.Budget_Purchase_Amount,
    	Terminal_Daily_Total.Budget_Purchase_Count,
    	Terminal_Daily_Total.Eigen_Return_Amount,
    	Terminal_Daily_Total.Eigen_Return_Count,
    	Terminal_Daily_Total.Budget_Return_Amount,
    	Terminal_Daily_Total.Budget_Return_Count
FROM 	Terminal_Daily_Total with(nolock)
	INNER JOIN
    	Terminal
		ON Terminal_Daily_Total.Terminal_ID = Terminal.Terminal_ID
	INNER JOIN
    	Location
		ON Terminal.Location_ID = Location.Location_ID
	INNER JOIN
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
     	LEFT OUTER JOIN
    	Credit_Card_Type
		ON  Terminal_Daily_Total.Eigen_CCT_Code = Credit_Card_Type.Eigen_Code

WHERE	DATEDIFF(dd, @busDate, RBR_Date) = 0

RETURN @@ROWCOUNT















GO
