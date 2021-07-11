USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCashPaymentRefundMethod]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PURPOSE: 	To retrieve a list of cash payment/refund methods..
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllCashPaymentRefundMethod]
AS

SELECT	Code,
		Value

FROM		Lookup_Table

WHERE	Category = 'Cash Payment Method'
OR		Category = 'Cash Refund Method'

ORDER BY	Code

RETURN 1











GO
