USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateSpclRestriction]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetResRateSpclRestriction
PURPOSE: To retrieve special rate restrictions
AUTHOR: Don Kirkby
DATE CREATED: Mar 17, 1999
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetResRateSpclRestriction]
	@RateId Varchar(10),
	@CurrDate Varchar(24)
AS
DECLARE @iRateId 	Integer
DECLARE @dCurrDate 	Datetime
	SELECT 	@iRateId = Convert(Integer, NULLIF(@RateId,"")),
		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,""))

	SELECT	Special_Restrictions
	FROM	Vehicle_Rate
	WHERE	Rate_Id = @iRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date










GO
