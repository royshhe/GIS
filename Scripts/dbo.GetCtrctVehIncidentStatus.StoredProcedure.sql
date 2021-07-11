USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehIncidentStatus]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctVehIncidentStatus    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctVehIncidentStatus    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctVehIncidentStatus    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctVehIncidentStatus    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To return 'unresolved' if there exists ANY support incident with outstanding status (b)
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctVehIncidentStatus]
	@CtrctNum	VarChar(10)
AS
	DECLARE @sStatus Varchar(15)
	DECLARE @nCtrctNum Integer

	/* 3/27/99 - cpy bug fix - return 'unresolved' if there exists ANY support incident
				with outstanding status (b) */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	Set Rowcount 1
	
	SELECT	@nCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	@sStatus = 'Unresolved'
	FROM	Vehicle_On_Contract VOC,
		Vehicle_Support_Incident VSI
	
	WHERE	VOC.Contract_Number = @nCtrctNum
	AND	VOC.Contract_Number = VSI.Contract_Number
	AND	VOC.Unit_Number = VSI.Unit_Number
	AND	VSI.Incident_Status = 'b'
	ORDER BY
		VSI.Checked_Out DESC

	IF @@ROWCOUNT = 0
		SELECT 	@sStatus = 'Resolved'
		FROM	Vehicle_On_Contract VOC,
			Vehicle_Support_Incident VSI
	
		WHERE	VOC.Contract_Number = @nCtrctNum
		AND	VOC.Contract_Number = VSI.Contract_Number
		AND	VOC.Unit_Number = VSI.Unit_Number
		AND	VSI.Incident_Status = 'a'
		ORDER BY
			VSI.Checked_Out DESC

	SELECT 'Status' = @sStatus
	WHERE	@sStatus IS NOT NULL

	RETURN @@ROWCOUNT













GO
