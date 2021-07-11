USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_1_Credit_Card_Balancing_SR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*
PROCEDURE NAME: RP_SP_CCI_1_Credit_Card_Balancing_SR
PURPOSE: Select all the information needed for Credit Card Detail Subreport of Credit Card Balancing Report.
	
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY: Credit Card Balancing Report (Credit Card Detail Subreport)
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_CCI_1_Credit_Card_Balancing_SR]
(
	@paramBusDate varchar(20) = '22 Apr 1999'
)

AS

-- convert strings to datetime

DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)

SELECT RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.RBR_Date,
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Terminal_ID,
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1.Credit_Card_Type,
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Collected_On,
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Document_Type,
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Document_Number,
     	dbo.ccmask(RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1.Credit_Card_Number,4,4),
     	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1.Customer_Name,
	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Amount,
    	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Authorization_Number
FROM 	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1 with(nolock)
	INNER JOIN
    	RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2
		ON  RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_1.Credit_Card_Key = RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2.Credit_Card_Key

WHERE	DATEDIFF(dd, @busDate, RBR_Date) = 0

RETURN @@ROWCOUNT














GO
