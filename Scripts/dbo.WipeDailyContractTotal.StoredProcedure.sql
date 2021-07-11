USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[WipeDailyContractTotal]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: WipeDailyContractTotal
PURPOSE: To set ALL daily contract totals to 0.
AUTHOR: Don Kirkby
DATE CREATED: Apr 07, 1999
CALLED BY: Eigen
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[WipeDailyContractTotal]
AS
	UPDATE	ar_credit_authorization
	   SET	daily_contract_total = 0








GO
