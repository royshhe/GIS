USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidateRBRDate]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.ValidateRBRDate    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRBRDate    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRBRDate    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRBRDate    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To return the count of number of Sales_Accessory_Sale_Payment records which RBR date equals the maximum of the RBR date for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[ValidateRBRDate]
@RefundedContractNum varchar(20)
AS
	/* 9/27/99 - do type conversion outside of select */

Declare @iRefundedCtrctNum Int
Declare @ret int
Declare @thisRBRDate datetime

SELECT @iRefundedCtrctNum = Convert(int, NULLIF(@RefundedContractNum,''))

Select @thisRBRDate =
	(SELECT
		Max(RBR_Date)
	FROM
		RBR_Date)
Select @ret =
	(Select

		Count(*)
	From
		Sales_Accessory_Sale_Payment
	Where
		Sales_Contract_Number = @iRefundedCtrctNum
		And RBR_Date> = @thisRBRDate-99)
Select @ret
Return @ret
GO
