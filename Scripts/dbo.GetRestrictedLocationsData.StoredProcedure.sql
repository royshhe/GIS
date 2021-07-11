USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRestrictedLocationsData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRestrictedLocationsData    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictedLocationsData    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictedLocationsData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetRestrictedLocationsData    Script Date: 11/23/98 3:55:34 PM ******/
/* NP - May 18 - Added ORder By */

CREATE PROCEDURE [dbo].[GetRestrictedLocationsData]
@UnitNumber varchar(10)
AS
Set Rowcount 2000
Select Distinct
	L.Location
From
	Location L,Vehicle_Location_Restriction VLR
Where
	VLR.Unit_Number=Convert(int,@UnitNumber)
	And VLR.Location_ID=L.Location_ID
	And L.Delete_Flag=0
Order By
	L.Location
Return 1













GO
