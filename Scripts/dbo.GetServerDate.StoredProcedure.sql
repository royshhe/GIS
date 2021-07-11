USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetServerDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetServerDate    Script Date: 2/18/99 12:11:40 PM ******/
/****** Object:  Stored Procedure dbo.GetServerDate    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetServerDate    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetServerDate    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: GetServerDate
PURPOSE: To retrieve the system date to the second.
AUTHOR: Don Kirkby
DATE CREATED: Oct 16, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetServerDate]
AS
	SELECT	CONVERT(varchar, GETDATE(),113)












GO
