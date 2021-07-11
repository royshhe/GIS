USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehLocationRestriction]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehLocationRestriction    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLocationRestriction    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLocationRestriction    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLocationRestriction    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Location_Restriction table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehLocationRestriction]
	@UnitNumber		VarChar(10),
	@LocationID		VarChar(10)
AS
	INSERT INTO Vehicle_Location_Restriction
	(
		Unit_Number,
		Location_ID
	)
	Values
	(
		CONVERT(Int, NULLIF(@UnitNumber, '')),
		CONVERT(SmallInt, NULLIF(@LocationID, ''))
	)
RETURN 1













GO
