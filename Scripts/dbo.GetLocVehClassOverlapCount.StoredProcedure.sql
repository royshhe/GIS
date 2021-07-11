USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocVehClassOverlapCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapCount    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapCount    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapCount    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocVehClassOverlapCount]
	@LocationVehicleClassID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)	
AS
	SELECT	CONVERT(VarChar, Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111)
	FROM	Location_Vehicle_Class
	WHERE	Location_Vehicle_Class_ID = CONVERT(SmallInt, @LocationVehicleClassID)
	AND	(	Valid_From > CONVERT(DateTime, @ValidFrom)
		OR
			Valid_To < CONVERT(DateTime, @ValidTo)
		)
	ORDER BY
		Valid_From		
RETURN 1












GO
