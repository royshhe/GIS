USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateMaintLevelData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateMaintLevelData    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateMaintLevelData    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRateMaintLevelData]
@RateID varchar(20)
AS
Set Rowcount 2000
Select Distinct
	Rate_Level
From
	Rate_Level
Where
	Rate_ID = Convert(int, @RateID)
	And Termination_Date = 'Dec 31 2078 11:59PM'
Return 1












GO
