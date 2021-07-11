USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateDamageIncident]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateDamageIncident    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.CreateDamageIncident    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateDamageIncident    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateDamageIncident    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Damage_Incident table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateDamageIncident]
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
	/* 10/21/99 - do nullif outside of SQL statements */

	SELECT	@Sequence = NULLIF(@Sequence, '')

--	Only one record for the given sequence
	DELETE	Damage_Incident
	WHERE	Vehicle_Support_Incident_Seq = CONVERT(Int, @Sequence)
	
	
	INSERT INTO Damage_Incident
		(	
			Vehicle_Support_Incident_Seq,
			Type,
			Vehicle_Location,
			Customer_Location,
			Vehicle_Drivable,
			Report_Required_At_Check_In,
			Current_KM,
			Vehicle_Model_Name,
			Vehicle_Serial_No,
			Vehicle_Exterior_Color
		)
	VALUES
		(
			CONVERT(Int, @Sequence),
			@Type,
			@VehicleLocation,
			@CustomerLocation,
			CONVERT(Bit, NULLIF(@VehicleDrivable, '')),
			CONVERT(Bit, NULLIF(@IncidentReportRequired, '')),
			CONVERT(Int, NULLIF(@CurrentKM, '')),
			NULLIF(@VehicleModelName, ''),
			@VehicleSerialNumber,
			@VehicleExteriorColor
		)
	RETURN @@RowCount














GO
