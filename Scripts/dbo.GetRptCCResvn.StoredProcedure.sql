USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptCCResvn]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptCCResvn]
	@CCTypeId Varchar(3),
	@RBRDate  Varchar(24),
	@NumDays  Varchar(5)
AS
	/* 7/29/99 - return reservations that had a payment/refund for a
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
	SELECT	Distinct RCDP.Confirmation_Number
	FROM	Reservation_CC_Dep_Payment RCDP WITH(NOLOCK)
		JOIN Reservation_Dep_Payment RDP
		  ON RCDP.Confirmation_Number = RDP.Confirmation_Number
		 AND RCDP.Collected_On = RDP.Collected_On
		JOIN Credit_Card CC
		  ON RCDP.Credit_Card_Key = CC.Credit_Card_Key
	WHERE	CC.Credit_Card_Type_Id = @CCTypeId
	AND   	RDP.Rbr_Date BETWEEN @dFrom AND @dTo
	ORDER BY RCDP.Confirmation_Number

	RETURN @@ROWCOUNT














GO
