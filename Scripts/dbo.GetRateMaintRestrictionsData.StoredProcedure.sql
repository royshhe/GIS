USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateMaintRestrictionsData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetRateMaintRestrictionsData    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateMaintRestrictionsData    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRateMaintRestrictionsData]
@RateID varchar(20)
AS
Set Rowcount 2000
Select
	Restriction_ID,
	Restriction_ID as RestrictionID,
	Number_Of_Hours,
	Number_Of_Days,
	Time_Of_Day
From
	Rate_Restriction
Where
	Rate_ID = Convert(int, @RateID)
	And Termination_Date = 'Dec 31 2078 11:59PM'
Order By
	Restriction_ID
Return 1
GO
