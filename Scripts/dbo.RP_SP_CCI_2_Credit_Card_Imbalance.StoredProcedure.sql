USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_2_Credit_Card_Imbalance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/*
PROCEDURE NAME: RP_SP_CCI_2_Credit_Card_Imbalance
PURPOSE: Select all information needed for Credit Card Imbalance Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY:  Credit Card Imbalance Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_CCI_2_Credit_Card_Imbalance]-- '2015-06-25'
(
	@paramBusDate varchar(20) = '01 September 1999'
)

AS

-- convert strings to datetime
DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)


SELECT
	Credit_Card_Transaction.RBR_Date,
    	Credit_Card_Transaction.Collected_At_Location_Id AS Location_ID,
     	Location.Location AS Location_Name,
    	Credit_Card_Transaction.Terminal_ID,
		Credit_Card_Transaction.Trx_Receipt_Ref_Num,
    	Credit_Card_Type.Credit_Card_Type,
    	Credit_Card_Transaction.System_Datetime,
    	Credit_Card_Transaction.[Function],
	Doc_Type = CASE WHEN Credit_Card_Transaction.Contract_Number IS NOT NULL
			   THEN 'Contract'
			   WHEN Credit_Card_Transaction.Confirmation_Number IS NOT NULL
			   THEN 'Reservation'
			   WHEN Credit_Card_Transaction.Sales_Contract_Number IS NOT NULL
			   THEN 'Acc. Sales'
		       END,
    	--ISNULL(Credit_Card_Transaction.Contract_Number,  ISNULL(Credit_Card_Transaction.Confirmation_Number,  Credit_Card_Transaction.Sales_Contract_Number )) AS Doc_Number,

ISNULL(convert(varchar(20),Credit_Card_Transaction.Contract_Number),  
	ISNULL(convert(varchar(20),Reservation.Foreign_Confirm_Number),
		ISNULL(convert(varchar(20),Credit_Card_Transaction.Confirmation_Number),  
			convert(varchar(20),Credit_Card_Transaction.Sales_Contract_Number) ))) AS Doc_Number,




    	right(dbo.ccmask(Credit_Card_Transaction.Credit_Card_Number,4,4),8) Credit_Card_Number,
    	Credit_Card_Transaction.Expiry,
   	Credit_Card_Transaction.Authorization_Number,
--	dbo.OM_CRTransReport.trn_id OM_trn_id,
    	Swipe = CASE WHEN Credit_Card_Transaction.Swiped_Flag = 0
		           THEN 'M'
		           ELSE 'S'
		END,
    	Credit_Card_Transaction.Last_Name + ', ' + Credit_Card_Transaction.First_Name AS Credit_Card_Name,
    	Credit_Card_Transaction.Amount,
    	Credit_Card_Transaction.Collected_By AS CSR_Name,
	IsVoid = CASE WHEN Credit_Card_Transaction.Void = 1 
			THEN 'Y'
			ELSE ''
			END,
	Credit_Card_Transaction.Short_Token
FROM	Credit_Card_Transaction with(nolock)
	INNER
	JOIN
    	Credit_Card_Type
		ON Credit_Card_Transaction.Credit_Card_Type_Id = Credit_Card_Type.Credit_Card_Type_ID
		AND Credit_Card_Transaction.Added_To_GIS = 0

--		INNER JOIN
--	      dbo.OM_CRTransReport ON 
--	      dbo.OM_CRTransReport.trn_card_type = dbo.Credit_Card_Type.Online_Mart_Code

     	INNER
	JOIN
    	Location
		ON Credit_Card_Transaction.Collected_At_Location_Id = Location.Location_ID
 	left outer join 
        Reservation
          on Credit_Card_Transaction.confirmation_number = Reservation.confirmation_number

WHERE	DATEDIFF(dd, @busDate, Credit_Card_Transaction.RBR_Date) = 0
And DATEDIFF(mi, Credit_Card_Transaction.System_Datetime, getdate()) >= 20









GO
