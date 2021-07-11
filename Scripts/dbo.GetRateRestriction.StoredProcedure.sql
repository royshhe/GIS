USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateRestriction]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateRestriction    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRateRestriction    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateRestriction    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateRestriction    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateRestriction]
	@Rate_ID varchar(20)
AS
DECLARE @iRateId Int
DECLARE @dTermDate Datetime

	/* 3/18/99 - cpy bug fix - return special restrictions */

	SELECT 	@iRateId = Convert(Int, NULLIF(@Rate_Id,'')),
		@dTermDate = Convert(Datetime, 'Dec 31 2078 11:59PM')

	Select
		RR.Number_Of_Hours, RR.Number_Of_Days, RR.Time_Of_Day,
	        Convert(char(1), R.Hour_Type), Convert(char(1),R.Day_Type),
        	Convert(char(1),R.Time_Type), R.Restriction
	From	
		Rate_Restriction RR, Restriction R
	Where
		RR.Rate_ID = @iRateId
		And RR.Termination_Date = @dTermDate
        	And RR.Restriction_ID = R.Restriction_ID

	UNION ALL

	SELECT	"0", "0", "0", "0", "0", "0", Special_Restrictions
	FROM	Vehicle_Rate
	WHERE	Rate_Id = @iRateId
	AND	Termination_Date = @dTermDate

	Return @@ROWCOUNT




















GO
