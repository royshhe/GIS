USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehSupportIncident]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehSupportIncident    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportIncident    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportIncident    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportIncident    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehSupportIncident]
	@Sequence Varchar(10)
AS
	/* 4/15/99 - cpy bug fix - instead of returning CON.LDW_Declined_reason code, return
				description; re-wrote to use left joins */

	Declare	@nSequence Integer
	Select		@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	VSI.Vehicle_support_Incident_Seq,
		VSI.Owning_Company_ID,
		VSI.Unit_Number,
		CONVERT(VarChar, VSI.Movement_Out, 111) Movement_Out_Date,
		CONVERT(VarChar, VSI.Movement_Out, 108) Movement_Out_Time,
		VSI.Contract_Number,
		CONVERT(VarChar, VSI.Checked_Out, 111) Checked_Out_Date,
		CONVERT(VarChar, VSI.Checked_Out, 108) Checked_Out_Time,
		VSI.Licence_Plate,
		VSI.Last_Name,
		VSI.First_Name,
		CONVERT(VarChar, VSI.Logged_On, 111) Logged_Date,
		CONVERT(VarChar, VSI.Logged_On, 108) Logged_Time,
		VSI.Logged_By,
		VSI.Incident_Status,
		VSI.Reported_By_Role,
		VSI.Reported_By_Name,
		VSI.Reported_By_Relationship,
		VSI.Incident_Type,
		CONVERT(Char(1), VSI.Do_Not_Switch_Vehicle),
		VSI.Do_Not_Switch_Reason,
		VSI.Claim_Number,
		VSI.Foreign_Contract_Number,
		VSI.Foreign_Vehicle_Unit_Number,
		LT.Value as LDW_Declined_reason, --CON.LDW_Declined_reason,
		CON.LDW_Declined_Details


	FROM	Vehicle_Support_Incident VSI
		LEFT JOIN Contract CON
		  ON VSI.Contract_Number = CON.Contract_Number

		LEFT JOIN Lookup_Table LT
		  ON CON.LDW_Declined_reason = LT.Code
		 AND LT.Category = 'LDW Declined Reason'

	WHERE	VSI.Vehicle_Support_Incident_Seq = @nSequence

	RETURN @@ROWCOUNT


















GO
