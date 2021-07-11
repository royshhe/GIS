USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCancel]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateCancel    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CreateCancel    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCancel    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCancel    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Contract_Turndown table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateCancel]
@Reason varchar(255), @EnteredBy varchar(20)
AS
Insert Into Contract_Turndown
	(Date, Cancellation_Reason, User_ID)
Values
	(getdate(), @Reason, @EnteredBy)
Return 1













GO
