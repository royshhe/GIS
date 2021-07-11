USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehSupportComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehSupportComment    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportComment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehSupportComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Support_Comment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehSupportComment]	

	@IncidentSeq	VarChar(10),
	@Comment	VarChar(255),
	@LoggedBy	VarChar(25),
	@LoggedOn	VarChar(24)
AS
	/* 4/15/99 - cpy bug fix - retrieve last seq# for this insert */

DECLARE @dCurrDatetime datetime,
	@NextSeq Int,
	@iIncidentSeq Int,
	@dLoggedOn datetime

	SELECT 	@dCurrDatetime = GetDate(),
		@iIncidentSeq = Convert(Int, NULLIF(@IncidentSeq,'')),
		@dLoggedOn = Convert(Datetime, NULLIF(@LoggedOn,''))

	-- get the max seq# for this incident
	SELECT 	@NextSeq = MAX(Comment_Seq) + 1
	FROM	Vehicle_Support_Comment
	WHERE	Vehicle_Support_Incident_Seq = @iIncidentSeq

	SELECT 	@NextSeq = ISNULL(@NextSeq, 1)

	INSERT INTO Vehicle_Support_Comment
		(	Vehicle_Support_Incident_Seq,
			Comment_Seq,
			Comment,
			Logged_By,
			Logged_On		)
	VALUES	(
			@iIncidentSeq,
			@NextSeq,
			@Comment,
			@LoggedBy,
			@LoggedOn
		)

	RETURN @@RowCount




















GO
