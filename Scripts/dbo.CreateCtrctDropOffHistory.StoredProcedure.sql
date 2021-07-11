USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctDropOffHistory]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateCtrctDropOffHistory    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctDropOffHistory    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctDropOffHistory    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctDropOffHistory    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Drop_Off_History table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateCtrctDropOffHistory]
	@CtrctNum	varchar(10),
	@DOLocId	varchar(10),
	@DODateTime	varchar(24),
	@ChangedBy	varchar(20),
	@ChangeOn	varchar(24),
	@Reason		varchar(255)
AS
	INSERT
	  INTO	Drop_Off_History
		(
		Contract_Number,
		Drop_Off_Location,
		Drop_Off_On,
		Changed_By,
		Changed_On,
		Reason
		)
	VALUES	(
		CONVERT(Int, NULLIF(@CtrctNum, '')),
		CONVERT(SmallInt, NULLIF(@DOLocId, '')),
		CONVERT(Datetime, NULLIF(@DODateTime, '')),
		@ChangedBy,
		CONVERT(Datetime, NULLIF(@ChangeOn, '')),
		@Reason
		)
	RETURN @@ROWCOUNT













GO
