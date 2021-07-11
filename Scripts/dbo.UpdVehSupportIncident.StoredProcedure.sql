USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehSupportIncident]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdVehSupportIncident    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehSupportIncident    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Vehicle_Support_Incident table .
MOD HISTORY:
Name    Date        	Comments
NP	Jan/12/2000	Added audit info
*/
/* NP - 99/04/16 - Removed variables which are not updatable */
CREATE PROCEDURE [dbo].[UpdVehSupportIncident]
	@Sequence			VarChar(10),
	@LoggedDate			VarChar(24),
	@LoggedBy			VarChar(20),
	@IncidentStatus			VarChar(1),
	@ReportedByRole		VarChar(25),
	@ReportedByName		VarChar(25),
	@ReportedByRelationship	VarChar(25),
	@IncidentType			VarChar(15),
	@DoNotSwitchVehicle		VarChar(1),
	@DoNotSwitchReason		VarChar(255),
	@ClaimNumber			VarChar(10),
	@LastUpdatedBy			VarChar(20)

AS
	Declare @nSequence int

	Select @nSequence = CONVERT(Int, NULLIF(@Sequence, ''))

	UPDATE	Vehicle_Support_Incident
	
	SET	Incident_Status			= @IncidentStatus,
		Reported_By_Role		= @ReportedByRole,
		Reported_By_Name		= @ReportedByName,
		Reported_By_Relationship	= @ReportedByRelationship,
		Incident_Type			= @IncidentType,
		Do_Not_Switch_Vehicle	= CONVERT(Bit, NULLIF(@DoNotSwitchVehicle, '')),
		Do_Not_Switch_Reason	= @DoNotSwitchReason,
		Claim_Number		= CONVERT(Int, NULLIF(@ClaimNumber, '')),
		Logged_On			= CONVERT(DateTime, NULLIF(@LoggedDate, '')),
		Logged_By			= NULLIF(@LoggedBy, ''),
		Last_Updated_By		= @LastUpdatedBy,
		Last_Updated_On		= GetDate()
		
	WHERE	
		Vehicle_Support_Incident_Seq 	= @nSequence

	RETURN 	1





















GO
