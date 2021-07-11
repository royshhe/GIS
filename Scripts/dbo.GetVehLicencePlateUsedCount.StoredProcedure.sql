USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehLicencePlateUsedCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehLicencePlateUsedCount    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateUsedCount    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateUsedCount    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateUsedCount    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehLicencePlateUsedCount]
	@LicencePlateNumber	VarChar(20),
	@LicencingProvinceState	VarChar(20),
	@UnitNumber		VarChar(10)
AS
	SELECT	Count(*)
	FROM	Vehicle_Licence_History
	WHERE	Licence_Plate_Number		= @LicencePlateNumber
	AND	Licencing_Province_State	= @LicencingProvinceState
	AND	Removed_On Is NULL
	AND	Unit_Number			<> CONVERT(Int, @UnitNumber)
	
RETURN 1












GO
