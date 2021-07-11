USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVoidTransaction]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[GetVoidTransaction]
	@sRbrDate varchar(20) 
AS
SELECT	Authorization_Number,
	Trx_Receipt_Ref_Num, 
	Credit_Card_Type_id, 
	Credit_Card_Number,
	Last_Name,
	First_Name,
	Expiry,
	Amount,
	Collected_by,
	Collected_At_Location_id,
	Swiped_flag,
	Contract_number,
	Confirmation_Number,
	Sales_Contract_number,
	Added_To_GIS,
	Entered_On_Handheld,
	[Function],
	RBR_Date
FROM	credit_card_transaction 
WHERE	Added_To_GIS = 0 AND
	RBR_Date = @sRbrDate AND	
	Void = -1 --disable void for now
GO
