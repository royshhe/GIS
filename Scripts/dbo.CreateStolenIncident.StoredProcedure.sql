USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateStolenIncident]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateStolenIncident    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.CreateStolenIncident    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateStolenIncident    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateStolenIncident    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Stolen_Incident table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateStolenIncident]
	@Sequence		VarChar(10),
	@Reported		VarChar(1),
	@CaseNumber		VarChar(20),
	@Detachment		VarChar(20),
	@ContactName		VarChar(25),
	@ContactPhone		VarChar(35),
	@CustomerLocation	VarChar(128),
	@KeyLocation		VarChar(128),
	@LastSeenLocation	VarChar(128),
	@LastSeenOn		VarChar(24),
	@NoticedMissingAt	VarChar(24),
	@CustomerContactPhone	VarChar(35)
AS
--	Only one record for the given sequence
	DELETE	Stolen_Incident
	WHERE	Vehicle_Support_Incident_Seq = CONVERT(Int, NULLIF(@Sequence, ''))
	
	
	INSERT INTO Stolen_Incident
		(	
			Vehicle_Support_Incident_Seq,
			Reported_To_Police,
			Case_Number,
			Detachment,
			Contact_Name,
			Contact_Phone,
			Customer_Location,
			Key_Location,
			Last_Seen_Location,
			Last_Seen_On,
			Noticed_Missing_At,
			Customer_Contact_Phone
		)
	VALUES
		(
			CONVERT(Int, NULLIF(@Sequence, '')),
			CONVERT(Bit, NULLIF(@Reported, '')),
			@CaseNumber,
			@Detachment,
			@ContactName,
			@ContactPhone,
			@CustomerLocation,
			@KeyLocation,
			@LastSeenLocation,
			CONVERT(DateTime, NULLIF(@LastSeenOn, '')),
			CONVERT(DateTime, NULLIF(@NoticedMissingAt, '')),
			@CustomerContactPhone
		)
	RETURN @@RowCount













GO
