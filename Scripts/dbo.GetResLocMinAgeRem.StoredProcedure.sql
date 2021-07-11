USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResLocMinAgeRem]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResLocMinAgeRem    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocMinAgeRem    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocMinAgeRem    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResLocMinAgeRem    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResLocMinAgeRem]
	@VehClassCode Varchar(1)
AS
	IF @VehClassCode = ""	SELECT @VehClassCode = NULL
	SELECT 	Minimum_Age
	FROM	Vehicle_Class
	WHERE	Vehicle_Class_Code = @VehClassCode

	RETURN @@ROWCOUNT












GO
