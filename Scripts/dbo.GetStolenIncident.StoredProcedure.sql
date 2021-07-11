USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetStolenIncident]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetStolenIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetStolenIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetStolenIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetStolenIncident    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetStolenIncident]
	@Sequence Varchar(10)
AS
	DECLARE	@nSequence Integer
	SELECT	@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	CONVERT(Char(1), Reported_To_Police),
		Case_Number,
		Detachment,
		Contact_Name,
		Contact_Phone,
		Customer_Location,
		Key_Location,
		Last_Seen_Location,
		CONVERT(VarChar, Last_Seen_On, 111) Last_Seen_Date,
		CONVERT(VarChar, Last_Seen_On, 108) Last_Seen_Time,
		CONVERT(VarChar, Noticed_Missing_At, 111) Noticed_Missing_Date,
		CONVERT(VarChar, Noticed_Missing_At, 108) Noticed_Missing_Time,
		Customer_Contact_Phone
	FROM	Stolen_Incident
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	RETURN @@ROWCOUNT













GO
