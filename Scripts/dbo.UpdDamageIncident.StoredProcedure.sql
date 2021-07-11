USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdDamageIncident]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdDamageIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.UpdDamageIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdDamageIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdDamageIncident    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Damage_Incident table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdDamageIncident]
	@Sequence		VarChar(10),
	@Type			VarChar(30),
	@VehicleLocation	VarChar(128),
	@CustomerLocation	VarChar(128),
	@VehicleDrivable	VarChar(1),
	@IncidentReportRequired	VarChar(1),
	@CurrentKM		VarChar(10),
	@VehicleModelName	VarChar(25),
	@VehicleSerialNumber	VarChar(30),
	@VehicleExteriorColor	VarChar(15)
AS
	Declare	@nSequence Integer
	Select		@nSequence = CONVERT(Int, NULLIF(@Sequence, ''))

	UPDATE	Damage_Incident
	SET	Type = 				@Type,
		Vehicle_Location = 		@VehicleLocation,
		Customer_Location = 		@CustomerLocation,
		Vehicle_Drivable = 		CONVERT(Bit, NULLIF(@VehicleDrivable, '')),
		Report_Required_At_Check_In =	CONVERT(Bit, NULLIF(@IncidentReportRequired, '')),
		Current_KM = 			CONVERT(Int, NULLIF(@CurrentKM, '')),
		Vehicle_Model_Name = 		NULLIF(@VehicleModelName, ''),
		Vehicle_Serial_No = 		@VehicleSerialNumber,
		Vehicle_Exterior_Color = 	@VehicleExteriorColor

	WHERE	Vehicle_Support_Incident_Seq = 	@nSequence

	RETURN @@RowCount














GO
