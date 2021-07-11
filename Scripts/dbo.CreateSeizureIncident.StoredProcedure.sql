USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSeizureIncident]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateSeizureIncident    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.CreateSeizureIncident    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSeizureIncident    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSeizureIncident    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Seizure_Incident table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSeizureIncident]
	@Sequence		VarChar(10),
	@SeizureLocation	VarChar(128),
	@SeizuredOn		VarChar(24),
	@Reason			VarChar(255),
	@VehicleLocation	VarChar(128),
	@ReportingAuthority	VarChar(30),
	@ContactName		VarChar(25),
	@ContactPosition	VarChar(20),
	@ContactPhone		VarChar(35)
AS
--	Only one record for the given sequence
	DELETE	Seizure_Incident
	WHERE	Vehicle_Support_Incident_Seq = CONVERT(Int, NULLIF(@Sequence, ''))
	
	
	INSERT INTO Seizure_Incident
		(	
			Vehicle_Support_Incident_Seq,
			Seizure_Location,
			Seizure_On,
			Reason,
			Vehicle_Location,
			Reporting_Authority,
			Contact_Name,
			Contact_Position,
			Contact_Phone
		)
	VALUES
		(
			CONVERT(Int, NULLIF(@Sequence, '')),
			@SeizureLocation,
			CONVERT(DateTime, NULLIF(@SeizuredOn, '')),
			@Reason,
			@VehicleLocation,
			@ReportingAuthority,
			@ContactName,
			@ContactPosition,
			@ContactPhone
		)
	RETURN @@RowCount













GO
