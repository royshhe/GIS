USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehLicenceHistory]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdVehLicenceHistory    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehLicenceHistory    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehLicenceHistory    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehLicenceHistory    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Vehicle_Licence_History table .
MOD HISTORY:
Name    Date        Comments
*/
/*Moved NULLIF out of the Where clause */
CREATE PROCEDURE [dbo].[UpdVehLicenceHistory]
	@UnitNumber		VarChar(10),
	@LicencePlateNumber	VarChar(20),
	@LicencingProvinceState	VarChar(20),
	@OldAttachedOn		VarChar(24),
	@AttachedOn		VarChar(24),
	@RemovedOn		VarChar(24)
AS
	Declare @nUnitNumber Int
	Declare @dOldAttachedOn DateTime

	Select @nUnitNumber	= CONVERT(Int, NULLIF(@UnitNumber, ''))
	Select @dOldAttachedOn	= CONVERT(DateTime, NULLIF(@OldAttachedOn, ''))

	If @OldAttachedOn= ''
		Select @OldAttachedOn= NULL
	If @AttachedOn= ''
		Select @AttachedOn= NULL
	If @RemovedOn = ''
		Select @RemovedOn = NULL

	UPDATE	Vehicle_Licence_History

	SET	Attached_ON			= CONVERT(DateTime, @AttachedOn),
		Removed_On			= CONVERT(DateTime, @RemovedOn)

	WHERE	Unit_Number 		= @nUnitNumber
	AND	Licence_Plate_Number	= @LicencePlateNumber
	AND	Licencing_Province_State	= @LicencingProvinceState
	AND	Attached_On			= @dOldAttachedOn
RETURN 1














GO
