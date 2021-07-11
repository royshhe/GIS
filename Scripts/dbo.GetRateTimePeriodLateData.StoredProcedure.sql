USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateTimePeriodLateData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateTimePeriodLateData    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRateTimePeriodLateData    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRateTimePeriodLateData]
@RateID varchar(20)
AS
Set Rowcount 2000
Select
	Rate_Time_Period_ID,
	Time_Period,
	Time_Period_Start,
	Time_Period_End,
	(Case
		When Km_Cap IS NULL Then
			'Unlimited'
		Else
			Convert(varchar, Km_Cap)
		End)
From
	Rate_Time_Period
Where	
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
	And Type='Late'
Order By
	Rate_Time_Period_ID
Return 1












GO
