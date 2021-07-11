USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgRateLevelByBCDNo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOrgRateLevelByBCDNo    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateLevelByBCDNo    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateLevelByBCDNo    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgRateLevelByBCDNo    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgRateLevelByBCDNo]
@BCDNum    char(10),
@PickupDate varchar(20)
AS
Select Distinct
	B.Rate_ID, B.Rate_Level
From
	Organization A, Organization_Rate B
Where
	A.BCD_Number=@BCDNum
	And A.Organization_ID=B.Organization_ID
	And B.Termination_Date = 'Dec 31 2078 11:59PM'

	And B.Valid_From <= Convert(datetime, @PickupDate)
	And B.Valid_To >= Convert(datetime, @PickupDate)
Return 1












GO
