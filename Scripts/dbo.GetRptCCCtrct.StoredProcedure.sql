USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptCCCtrct]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








CREATE PROCEDURE [dbo].[GetRptCCCtrct]
	@CCTypeId Varchar(3),
	@RBRDate  Varchar(24),
	@NumDays  Varchar(5)
AS
	/* 7/29/99 - return contracts that had a payment/refund for a given card type
			and date */
	/* 10/14/99 - do type conversion and nullif outside of SQL statement */

DECLARE	@cntDays int,
	@dFrom datetime,
	@dTo datetime
--
	SELECT	@cntDays = CAST(NULLIF(@NumDays, '') as int),
		@dTo = CAST(NULLIF(@RBRDate, '') as datetime),
		@CCTypeId = NULLIF(@CCTypeId,'')
--
	SELECT	@dFrom = DATEADD(day, 1-@cntDays, @dTo)
--
	SELECT	DISTINCT CCP.Contract_Number
	FROM	Credit_Card_Payment CCP WITH(NOLOCK)
		JOIN Contract_Payment_Item CPI
		  ON CCP.Contract_number = CPI.Contract_Number
		 AND CCP.Sequence = CPI.Sequence
		JOIN Credit_Card CC
		  ON CC.Credit_Card_Key = CCP.Credit_Card_Key
	WHERE	CC.Credit_Card_Type_Id = @CCTypeId
	AND   	CPI.Rbr_Date BETWEEN @dFrom AND @dTo
	ORDER BY CCP.Contract_Number

	RETURN @@ROWCOUNT












GO
