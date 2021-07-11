USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehSupportIncident]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehSupportIncident    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportIncident    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportIncident    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportIncident    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Support_Incident table.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/12/2000	Added audit info
 */
/* np - 99/04/16 - Removed IsForeingContract flag*/

CREATE PROCEDURE [dbo].[CreateVehSupportIncident]
	@UnitNumber			VarChar(10),
	@MoveMentOut			VarChar(24),
	@ContractNumber		VarChar(10),
	@CheckedOut			VarChar(24),
	@LicencePlate			VarChar(10),
	@LastName			VarChar(25),
	@FirstName			VarChar(25),
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
	@ForeignContractNumber	VarChar(20),
	@ForeignVehicleUnitNumber	VarChar(20),
	@OwningCompanyID		VarChar(10),
	@LastUpdatedBy		VarChar(20)
AS
	INSERT INTO Vehicle_Support_Incident
		(	
			Unit_Number,
			Movement_Out,
			Contract_Number,
			Checked_Out,
			Licence_Plate,
			Last_Name,
			First_Name,
			Logged_On,
			Logged_By,
			Incident_Status,
			Reported_By_Role,
			Reported_By_Name,
			Reported_By_Relationship,
			Incident_Type,
			Do_Not_Switch_Vehicle,
			Do_Not_Switch_Reason,
			Claim_Number,
			Foreign_Contract_Number,
			Foreign_Vehicle_Unit_Number,
			Owning_Company_ID,
			Last_Updated_By,
			Last_Updated_On
		)
	VALUES
		(
			CONVERT(Int, NULLIF(@UnitNumber, '')),
			CONVERT(DateTime, NULLIF(@MoveMentOut, '')),
			CONVERT(Int, NULLIF(@ContractNumber, '')),
			CONVERT(DateTime, NULLIF(@CheckedOut, '')),
			@LicencePlate,
			@LastName,
			@FirstName,
			GetDate(),
			@LoggedBy,
			@IncidentStatus,
			@ReportedByRole,
			@ReportedByName,
			@ReportedByRelationship,
			@IncidentType,
			CONVERT(Bit, NULLIF(@DoNotSwitchVehicle, '')),
			@DoNotSwitchReason,
			CONVERT(Int, NULLIF(@ClaimNumber, '')),
			NULLIF(@ForeignContractNumber, ''),
			NULLIF(@ForeignVehicleUnitNumber, ''),
			CONVERT(SmallInt, NULLIF(@OwningCompanyID, '')),
			@LastUpdatedBy,
			GetDate()
		)
	RETURN @@IDENTITY




















GO
