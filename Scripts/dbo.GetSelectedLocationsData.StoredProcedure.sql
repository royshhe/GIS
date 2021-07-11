USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSelectedLocationsData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSelectedLocationsData    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedLocationsData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedLocationsData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedLocationsData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSelectedLocationsData]
@RateID varchar(20), @RateLocationSetID varchar(20)
AS
Set Rowcount 2000
Select
	A.Location
From
	Location A,Rate_Location_Set_Member B
Where
	A.Location_ID=B.Location_Id
	And B.Rate_ID=Convert(int,@RateID)
	And B.Rate_Location_Set_ID=Convert(int,@RateLocationSetID)
	And B.Termination_Date='Dec 31 2078 11:59PM'
	And A.Delete_Flag=0
Order By B.Rate_Location_Set_ID
Return 1












GO
