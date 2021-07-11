USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdStolenIncident]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdStolenIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.UpdStolenIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdStolenIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdStolenIncident    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Stolen_Incident table .
MOD HISTORY:
Name    Date        Comments
*/
/* moved NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[UpdStolenIncident]
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
	Declare @nSequence Integer
	Select @nSequence = CONVERT(Int, NULLIF(@Sequence, ''))
	
	UPDATE Stolen_Incident
	SET	Reported_To_Police = CONVERT(Bit, NULLIF(@Reported, '')),
		Case_Number = @CaseNumber,
		Detachment = @Detachment,
		Contact_Name = @ContactName,
		Contact_Phone = @ContactPhone,
		Customer_Location = @CustomerLocation,
		Key_Location = @KeyLocation,
		Last_Seen_Location = @LastSeenLocation,
		Last_Seen_On = CONVERT(DateTime, NULLIF(@LastSeenOn, '')),
		Noticed_Missing_At = CONVERT(DateTime, NULLIF(@NoticedMissingAt, '')),
		Customer_Contact_Phone = @CustomerContactPhone

	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	RETURN @@RowCount














GO
