USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMstroFields]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetMstroFields    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroFields    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroFields    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroFields    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetMstroFields
PURPOSE: To list the expected field tags
AUTHOR: Don Kirkby
DATE CREATED: Oct 7, 1998
CALLED BY: Maestro
REQUIRES:
ENSURES: returns the list of fields
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetMstroFields]
AS
	SELECT	tag,
		required
	  FROM	maestro_fields
	 ORDER
	    BY	tag
	
	RETURN @@ROWCOUNT












GO
