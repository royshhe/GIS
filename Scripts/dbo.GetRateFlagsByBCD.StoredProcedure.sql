USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateFlagsByBCD]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateFlagsByBCD    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateFlagsByBCD    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetRateFlagsByBCD
PURPOSE: To get some flags from the rate based on the organizations BCD number.
AUTHOR: Don Kirkby
DATE CREATED: Jan 21, 1999
CALLED BY: Rate
REQUIRES:
MOD HISTORY:
Name    Date        Comments
Don K	Mar 1 1999  Changed date constraints
Don K	Aug 9 1999  Use flags from org table and ignore dates
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateFlagsByBCD]
	@BCD		varchar(10),
	@ValidOn	varchar(24), -- ignored
	@BookedOn	varchar(24)  -- ignored
AS
	SELECT	@BCD = NULLIF(@BCD, '')

	SELECT	org.organization_id,
		CONVERT(tinyint, org.maestro_commission_paid) cpd,
		CONVERT(tinyint, org.maestro_freq_flyer_honoured) ffph
	  FROM	organization org
	 WHERE	org.inactive = 0
	   AND	org.bcd_number = @BCD















GO
