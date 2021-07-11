USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResVehClsAvail]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckResVehClsAvail    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CheckResVehClsAvail    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckResVehClsAvail    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckResVehClsAvail    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check whether the pickup date time for the vehicle class code is in between valid from and valid to..
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckResVehClsAvail]
	@VehClassCode Varchar(1),
	@PULocId Varchar(5),
	@PUDatetime Varchar(24)
AS
DECLARE @dLastDatetime Datetime
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 23:59")
	SELECT	"1"
	FROM	Location_vehicle_class A
	WHERE	Convert(Datetime,  @PUDatetime) BETWEEN A.Valid_From and
			ISNULL(A.Valid_To, @dLastDatetime)
	AND	A.Location_ID = Convert(SmallInt, @PULocId)
	AND	A.Vehicle_Class_Code = @VehClassCode
	RETURN @@ROWCOUNT













GO
