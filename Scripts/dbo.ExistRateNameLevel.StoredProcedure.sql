USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistRateNameLevel]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ExistRateNameLevel    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.ExistRateNameLevel    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: To retrieve the effective rate id for the given rate name and rate level.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[ExistRateNameLevel]
@RateName Varchar(35),
@RateLevel Varchar(1)
AS
Select
	VR.Rate_ID
From
	Vehicle_Rate VR,
	Rate_Level RL
Where
	VR.Rate_Name = @RateName
	And VR.Termination_Date = 'Dec 31 2078 11:59PM'
	And VR.Rate_ID = RL.Rate_ID
	And RL.Rate_Level = @RateLevel
	And RL.Termination_Date = 'Dec 31 2078 11:59PM'
Return 1













GO
