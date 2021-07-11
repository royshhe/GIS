USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSeizureIncident]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSeizureIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetSeizureIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSeizureIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSeizureIncident    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */

CREATE PROCEDURE [dbo].[GetSeizureIncident]
	@Sequence Varchar(10)
AS
	DECLARE	@nSequence Integer
	SELECT	@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	Seizure_Location,
		CONVERT(VarChar, Seizure_On, 111) Seizure_Date,
		CONVERT(VarChar, Seizure_On, 108) Seizure_Time,
		Reason,
		Vehicle_Location,
		Reporting_Authority,
		Contact_Name,
		Contact_Position,
		Contact_Phone
	FROM	Seizure_Incident
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	RETURN @@ROWCOUNT













GO
