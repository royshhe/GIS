USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_5_Credit_Card_Imbalance_Reciept]    Script Date: 2021-07-10 1:50:50 PM ******/
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
CREATE PROCEDURE [dbo].[RP_SP_CCI_5_Credit_Card_Imbalance_Reciept] --'1785421'
(
	@ContractNumber varchar(20) 
)

AS

select 
	Authorization_Number,
	Credit_Card_Type,
	Credit_Card_Number,
	Last_Name,
	First_Name,
	Expiry,
	Amount,                                  
	Collected_By,
	Collected_At_Location_Id,
	Terminal_ID,
	Trx_Receipt_Ref_Num,
	Trx_ISO_Response_Code,
	Trx_Remarks,                                                                                
	Swiped_Flag, 
	convert(varchar(20),Contract_Number) Contract_Number,
	Confirmation_Number,
	Sales_Contract_Number,
	--Added_To_GIS,
	--Entered_On_Handheld,
	--Function,
	RBR_Date,
	System_Datetime,         
	--Void,
	Short_Token
from credit_card_transaction cctran 
		inner join credit_card_type cct  on cctran.credit_card_type_id=cct.credit_card_type_id
where added_to_gis=0
		and contract_number=@ContractNumber

RETURN @@ROWCOUNT


GO
