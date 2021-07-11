USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSARefundedByInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSSARefundedByInfo    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetSSARefundedByInfo    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetSSARefundedByInfo]
@SalesContractNum Varchar(11)
AS
	/* 9/27/99 - do type conversion outside of select */
DECLARE @iSalesCtrctNum Int

	SELECT @iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,""))

SELECT
	Sales_Contract_Number
FROM
	Sales_Accessory_Sale_Contract
WHERE
	Refunded_Contract_No = @iSalesCtrctNum
	
RETURN @@ROWCOUNT













GO
