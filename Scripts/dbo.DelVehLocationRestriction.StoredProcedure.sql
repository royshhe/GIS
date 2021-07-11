USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelVehLocationRestriction]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelVehLocationRestriction    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DelVehLocationRestriction    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelVehLocationRestriction    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelVehLocationRestriction    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Vehicle_Location_Restriction table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DelVehLocationRestriction]
	@UnitNumber		VarChar(10),
	@LocationID		VarChar(10)
AS
	DELETE	Vehicle_Location_Restriction
	WHERE	Unit_Number	= CONVERT(Int, @UnitNumber)
	AND	Location_ID	= CONVERT(SmallInt, @LocationID)
RETURN 1













GO
