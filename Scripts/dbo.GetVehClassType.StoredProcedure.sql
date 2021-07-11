USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassType]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehClassType    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassType    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassType    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassType    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehClassType]
	@VehClassCode Varchar(1)
AS
	/* 9/30/99 - do nullif outside of select */

	SELECT 	@VehClassCode = NULLIF(@VehClassCode,'')

	SELECT	Vehicle_Type_ID
	FROM	Vehicle_Class
	WHERE	Vehicle_Class_Code = @VehClassCode
	RETURN @@ROWCOUNT













GO
