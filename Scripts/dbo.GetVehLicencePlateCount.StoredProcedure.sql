USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehLicencePlateCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetVehLicencePlateCount    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateCount    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateCount    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehLicencePlateCount    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehLicencePlateCount]
	@LicencePlateNumber	VarChar(20),
	@LicencingProvinceState	VarChar(20)
AS
	SELECT	Count(*)
	FROM	Vehicle_Licence
	WHERE	Licence_Plate_Number		= @LicencePlateNumber
	AND	Licencing_Province_State	= @LicencingProvinceState
	and delete_flag='0'
	
RETURN 1













GO
