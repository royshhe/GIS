USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationsGroupsIDsData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











CREATE PROCEDURE [dbo].[GetLocationsGroupsIDsData]
@RateID varchar(20)
AS
Set Rowcount 2000
Select
	Rate_Location_Set_ID
From
	Rate_Location_Set
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Order By Rate_Location_Set_ID
Return 1











GO
