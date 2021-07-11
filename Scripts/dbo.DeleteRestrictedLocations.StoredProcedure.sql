USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRestrictedLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteRestrictedLocations    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRestrictedLocations    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRestrictedLocations    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRestrictedLocations    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Vehicle_Location_Restriction table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteRestrictedLocations]
@UnitNumber varchar(10)
AS
Delete From
	 Vehicle_Location_Restriction
Where
	Unit_Number=Convert(int,@UnitNumber)
	
Return 1













GO
