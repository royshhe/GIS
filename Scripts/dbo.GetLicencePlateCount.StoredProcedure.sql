USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLicencePlateCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLicencePlateCount    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetLicencePlateCount    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLicencePlateCount    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetLicencePlateCount]
	@Province VarChar(20),
	@PlateNumber VarChar(10)
AS
   	SELECT	Count(*)
	FROM	Vehicle_Licence
	WHERE	Licencing_Province_State= @Province
	AND	Licence_Plate_Number	= @PlateNumber
   	RETURN 1












GO
