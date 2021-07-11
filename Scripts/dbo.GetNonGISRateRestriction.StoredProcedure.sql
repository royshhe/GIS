USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateRestriction]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetNonGISRateRestriction    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateRestriction    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateRestriction    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetNonGISRateRestriction]
	@QuotedRateId Varchar(10)
AS
DECLARE @iRateId 	Integer
	SELECT 	@iRateId = Convert(Integer, NULLIF(@QuotedRateId,""))
	SELECT 	RestrictDesc = CASE
			WHEN R.Hour_Type = 1 THEN
				Convert(Varchar(3), QRR.Number_of_Hours) + " "  + R.Restriction
			WHEN R.Day_Type = 1 THEN
				Convert(Varchar(3), QRR.Number_of_Days) + " "  + R.Restriction
			WHEN R.Time_Type = 1 THEN
				R.Restriction + " " + QRR.Time_Of_Day
			ELSE	
				R.Restriction
		END,
		QRR.Restriction_ID,
		RestrictNum = CASE
			WHEN R.Hour_Type = 1 THEN
				Convert(Varchar(3), QRR.Number_of_Hours)
			WHEN R.Day_Type = 1 THEN
				Convert(Varchar(3), QRR.Number_of_Days)
			WHEN R.Time_Type = 1 THEN
				QRR.Time_Of_Day
			ELSE	
				NULL
		END
	FROM	Restriction R,
		Quoted_Rate_Restriction QRR
	WHERE	QRR.Restriction_ID = R.Restriction_ID
	AND	QRR.Quoted_Rate_ID = @iRateId
	RETURN @@ROWCOUNT












GO
