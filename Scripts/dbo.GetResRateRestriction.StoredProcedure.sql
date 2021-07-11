USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateRestriction]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetResRateRestriction
PURPOSE: To retrieve special rate restrictions
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
Don K	Mar 17 1999 Removed special restrictions to GetResRateSpclRestriction
*/
CREATE PROCEDURE [dbo].[GetResRateRestriction]
	@RateId Varchar(10),
	@CurrDate Varchar(24)
AS
DECLARE @iRateId 	Integer
DECLARE @dCurrDate 	Datetime
	/* 981110 - cpy - removed temp table use */
	SELECT 	@iRateId = Convert(Integer, NULLIF(@RateId,"")),
		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,""))
	SELECT 	RestrictDesc = CASE
			WHEN A.Hour_Type = 1 THEN
				Convert(Varchar(3), B.Number_of_Hours) + " "  + A.Restriction
			WHEN A.Day_Type = 1 THEN
				Convert(Varchar(3), B.Number_of_Days) + " "  + A.Restriction
			WHEN A.Time_Type = 1 THEN
				A.Restriction + " " + B.Time_Of_Day
			ELSE	
				A.Restriction
		END,
		B.Restriction_ID,
		RestrictNum = CASE
			WHEN A.Hour_Type = 1 THEN
				Convert(Varchar(3), B.Number_of_Hours)
			WHEN A.Day_Type = 1 THEN
				Convert(Varchar(3), B.Number_of_Days)
			WHEN A.Time_Type = 1 THEN
				B.Time_Of_Day
			ELSE	
				NULL
		END
	FROM	Restriction A,
		Rate_Restriction B
	WHERE	B.Restriction_ID = A.Restriction_ID
	AND	B.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date AND B.Termination_Date
	ORDER BY 2, 1
	RETURN @@ROWCOUNT








GO
