USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRPurposeByMstro]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRPurposeByMstro    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetRPurposeByMstro    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRPurposeByMstro    Script Date: 1/11/99 1:03:16 PM ******/
/*
PROCEDURE NAME: GetRPurposeByMstro
PURPOSE: To retrieve the Rate Purpose associated with a Maestro indicator
AUTHOR: Don Kirkby
DATE CREATED: Dec 1, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRPurposeByMstro]
	@MstroInd	varchar(1)
AS
/*IF @MstroInd != ''*/
	SELECT	rate_purpose_id
	  FROM	rate_purpose
	 WHERE	maestro_rate_indicator = @MstroInd
	   AND	maestro_rate_indicator != ''












GO
