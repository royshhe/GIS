USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehSupportActionLog]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehSupportActionLog    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportActionLog    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportActionLog    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportActionLog    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Support_Action_Log table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehSupportActionLog]	
	@IncidentSeq	VarChar(10),
	@Action		VarChar(255),
	@ContactInfo	VarChar(255),
	@LoggedBy	VarChar(25),
	@LoggedOn	VarChar(24)
AS
	/* 4/15/99 - cpy bug fix - retrieve last seq# for this insert
				- change @Action param length from 12 to 255 */

DECLARE @dCurrDatetime datetime,
	@NextSeq Int,
	@iIncidentSeq Int,
	@dLoggedOn datetime

	SELECT 	@dCurrDatetime = GetDate(),
		@iIncidentSeq = Convert(Int, NULLIF(@IncidentSeq,'')),
		@dLoggedOn = Convert(Datetime, NULLIF(@LoggedOn,''))

	-- get the max seq# for this incident
	SELECT 	@NextSeq = MAX(Action_Seq) + 1
	FROM	Vehicle_Support_Action_Log
	WHERE	Vehicle_Support_Incident_Seq = @iIncidentSeq

	SELECT 	@NextSeq = ISNULL(@NextSeq, 1)

	INSERT INTO Vehicle_Support_Action_Log
		(	Vehicle_Support_Incident_Seq,
			Action_Seq,
			Action,
			Contact_Information,
			Logged_By,
			Logged_On	
		)
	VALUES	(	@iIncidentSeq,
			@NextSeq,
			@Action,
			@ContactInfo,
			@LoggedBy,
			@dLoggedOn
		)

	RETURN @@RowCount














GO
