USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptCCSAS]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptCCSAS]
	@CCTypeId Varchar(3),
	@RBRDate  Varchar(24),
	@NumDays  Varchar(5)
AS
	/* 7/29/99 - return sales contracts that had a payment/refund for a
			given card type	and date */

DECLARE	@cntDays int,
	@dFrom datetime,
	@dTo datetime
--
	SELECT	@CCTypeId = NULLIF(@CCTypeId,'')

	SELECT	@cntDays = CAST(NULLIF(@NumDays, '') as int),
		@dTo = CAST(NULLIF(@RBRDate, '') as datetime)
--
	SELECT	@dFrom = DATEADD(day, 1-@cntDays, @dTo)
--
	SELECT	Distinct SACP.Sales_Contract_Number
	FROM	Sales_Accessory_CrCard_Payment SACP
		JOIN Sales_Accessory_Sale_Payment SASP
		  ON SACP.Sales_Contract_Number = SASP.Sales_Contract_Number
		JOIN Credit_Card CC
		  ON CC.Credit_Card_Key = SACP.Credit_Card_Key
	WHERE	CC.Credit_Card_Type_Id = @CCTypeId
	AND   	SASP.Rbr_Date BETWEEN @dFrom AND @dTo
	ORDER BY SACP.Sales_Contract_Number

	RETURN @@ROWCOUNT












GO
