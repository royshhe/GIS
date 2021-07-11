USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateDropOffLocs]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateDropOffLocs    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocs    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocs    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateDropOffLocs    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateDropOffLocs]
@RateID varchar(20)
AS
Set Rowcount 2000
Select
	RLS.Rate_Location_Set_ID,Convert(char(1),RLS.Allow_All_Auth_Drop_Off_Locs) AS "Loc",
	RDOL.Location_ID
From
	Rate_Location_Set RLS, Rate_Drop_Off_Location RDOL
Where
	RLS.Rate_ID=Convert(int,@RateID)
	And RLS.Rate_Location_Set_ID=RDOL.Rate_Location_Set_ID
	And RLS.Termination_Date='Dec 31 2078 11:59PM'
	And RDOL.Termination_Date='Dec 31 2078 11:59PM'
Return 1













GO
