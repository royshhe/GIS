USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccSaleARPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To insert a record into Sales_Accessory_AR_Payment table.
MOD HISTORY:
Name    Date        Comments
LQ	Jan 22 2001	required by tracker 1787
 */

CREATE PROCEDURE [dbo].[CreateSalesAccSaleARPayment]
	@SalesContractNumber	VarChar(20),
	@CustomerCode		Varchar(12),
	@PONumber		Varchar(20)
	
AS
	

	INSERT INTO Sales_Accessory_AR_Payment
		(
		Sales_Contract_Number,
		Customer_Code,
		PO_Number
		)
	VALUES
		(
		Convert(int, NULLIF(@SalesContractNumber,'')),
		@CustomerCode,
		@PONumber
		)
RETURN 1



GO
