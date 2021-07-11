USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResLocRem]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResLocRem    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocRem    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocRem    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocRem    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResLocRem]
	@LocId Varchar(5)
AS
	IF @LocId = "" 	SELECT @LocId = NULL
	SELECT 	Address_1, Address_2, City, Address_Description,
		Hours_Of_Service_Description
	FROM 	Location
	WHERE 	Location_Id = Convert(SmallInt, @LocId)
	RETURN @@ROWCOUNT












GO
