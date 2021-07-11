USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehLicenceHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehLicenceHistory    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLicenceHistory    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLicenceHistory    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehLicenceHistory    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Licence_History table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehLicenceHistory]
	@UnitNumber		VarChar(10),
	@LicencePlateNumber	VarChar(20),
	@LicencingProvinceState	VarChar(20),
	@AttachedOn		VarChar(24),
	@RemovedOn		VarChar(24)
AS
	If @AttachedOn= ''
		Select @AttachedOn= NULL
	If @RemovedOn = ''
		Select @RemovedOn = NULL
	INSERT INTO Vehicle_Licence_History
		(
		Unit_Number,
		Licence_Plate_Number,
		Licencing_Province_State,
		Attached_On,
		Removed_On
		)
	VALUES
		(
		CONVERT(Int, @UnitNumber),
		@LicencePlateNumber,
		@LicencingProvinceState,
		CONVERT(DateTime, @AttachedOn),
		CONVERT(DateTime, @RemovedOn)
		)
RETURN 1













GO
