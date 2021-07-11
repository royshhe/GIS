USE [GISData]
GO
/****** Object:  View [dbo].[RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1
PURPOSE: Get information about credit cards
	
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_CCI_1_Credit_Card_Balancing_L2_SB_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1]
AS
SELECT	Credit_Card.Credit_Card_Key, 
	Credit_Card.Last_Name + ' ' + Credit_Card.First_Name AS Customer_Name,
	Credit_Card.Credit_Card_Number, 
    	Credit_Card_Type.Credit_Card_Type
FROM 	Credit_Card WITH(NOLOCK)
	INNER JOIN
    	Credit_Card_Type 
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID


















GO
