USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistRateName]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ExistRateName    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.ExistRateName    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: To retrieve the effective rate id for the given rate name.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[ExistRateName]
@RateName Varchar(35)
AS
Select
	Rate_ID
From
	Vehicle_Rate
Where
	Rate_Name = @RateName
	And Termination_Date = 'Dec 31 2078 11:59PM'
Return 1













GO
