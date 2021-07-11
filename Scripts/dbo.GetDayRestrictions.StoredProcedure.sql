USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDayRestrictions]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetDayRestrictions    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetDayRestrictions    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetDayRestrictions    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetDayRestrictions    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve rate restriction details for the given rate id.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetDayRestrictions]
@Rate_ID varchar(20)
AS
Select
	RR.Number_Of_Days,upper(R.Restriction) as Restriction
From	
	Rate_Restriction RR, Restriction R

Where
	RR.Rate_ID=Convert(int,@Rate_ID)
	And RR.Termination_Date='Dec 31 2078 11:59PM'
	And R.Day_Type=1
        And RR.Restriction_ID=R.Restriction_ID
Return 1














GO
