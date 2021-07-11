USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdSeizureIncident]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdSeizureIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.UpdSeizureIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdSeizureIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdSeizureIncident    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Seizure_Incident table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 18 1999 - Moved NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[UpdSeizureIncident]
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
	Declare @nSequence Integer
	Select @nSequence = CONVERT(Int, NULLIF(@Sequence, ''))

	UPDATE Seizure_Incident
	SET	Seizure_Location = @SeizureLocation,
		Seizure_On = CONVERT(DateTime, NULLIF(@SeizuredOn, '')),
		Reason = @Reason,
		Vehicle_Location = @VehicleLocation,
		Reporting_Authority = @ReportingAuthority,
		Contact_Name = @ContactName,
		Contact_Position = @ContactPosition,
		Contact_Phone = @ContactPhone
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	RETURN @@RowCount














GO
