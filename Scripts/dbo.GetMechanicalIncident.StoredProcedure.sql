USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMechanicalIncident]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetMechanicalIncident    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetMechanicalIncident    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetMechanicalIncident    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetMechanicalIncident    Script Date: 11/23/98 3:55:33 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetMechanicalIncident]
	@Sequence Varchar(10)
AS
	DECLARE	@nSequence Integer
	SELECT	@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	Type,
		Vehicle_Location,
		Customer_Location,
		CONVERT(Char(1), Vehicle_Drivable),
		CONVERT(Char(1), Warranty_Repair),
		CONVERT(Char(1), Report_Required_At_Check_In),
		Current_KM,
		Vehicle_Model_Name,
		Vehicle_Serial_No,
		Vehicle_Exterior_Color
	FROM	Mechanical_Incident
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	RETURN @@ROWCOUNT













GO
