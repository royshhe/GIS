USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Imbalance]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		09 Oct 2003
--	Details		Credit Card Imbalance transaction summary
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------

CREATE view [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Imbalance]
as
SELECT
	Credit_Card_Transaction.RBR_Date,
    	Credit_Card_Transaction.Collected_At_Location_Id AS Location_ID,
     	Location.Location AS Location_Name,
    	--Credit_Card_Transaction.Terminal_ID,
    	Credit_Card_Type.Credit_Card_Type,
    	Credit_Card_Transaction.System_Datetime,
    	/*Credit_Card_Transaction.Function,
	Doc_Type = CASE WHEN Credit_Card_Transaction.Contract_Number IS NOT NULL
			   THEN 'Contract'
			   WHEN Credit_Card_Transaction.Confirmation_Number IS NOT NULL
			   THEN 'Reservation'
			   WHEN Credit_Card_Transaction.Sales_Contract_Number IS NOT NULL
			   THEN 'Acc. Sales'
		       END,*/
    	ISNULL(Credit_Card_Transaction.Contract_Number,  ISNULL(Credit_Card_Transaction.Confirmation_Number,  Credit_Card_Transaction.Sales_Contract_Number )) AS Doc_Number,
    	dbo.ccmask(Credit_Card_Transaction.Credit_Card_Number,4,4) Credit_Card_Number,
    	Credit_Card_Transaction.Expiry,
   	Credit_Card_Transaction.Authorization_Number,
    	/*Swipe = CASE WHEN Credit_Card_Transaction.Swiped_Flag = 0
		           THEN 'M'
		           ELSE 'S'
		END,
    	Credit_Card_Transaction.Last_Name + ', ' + Credit_Card_Transaction.First_Name AS Credit_Card_Name,*/
    	Credit_Card_Transaction.Amount,
    	Credit_Card_Transaction.Collected_By AS CSR_Name
FROM	Credit_Card_Transaction with(nolock)
	INNER
	JOIN
    	Credit_Card_Type
		ON Credit_Card_Transaction.Credit_Card_Type_Id = Credit_Card_Type.Credit_Card_Type_ID
		AND Credit_Card_Transaction.Added_To_GIS = 0
     	INNER
	JOIN
    	Location
		ON Credit_Card_Transaction.Collected_At_Location_Id = Location.Location_ID
GO
