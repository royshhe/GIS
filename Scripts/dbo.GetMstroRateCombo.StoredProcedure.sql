USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMstroRateCombo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetMstroRateCombo    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroRateCombo    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroRateCombo    Script Date: 1/11/99 1:03:16 PM ******/
/*
PROCEDURE NAME: GetMstroRateCombo
PURPOSE: To check if a combination Maestro Rate Categories is valid and return
	the Category that it should be processed as.
AUTHOR: Don Kirkby
DATE CREATED: Dec 2, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetMstroRateCombo]
	@RateStruct	varchar(1),
	@Ctgy1		varchar(2),
	@Ctgy2		varchar(2),
	@Ctgy3		varchar(2),
	@Ctgy4		varchar(2)
AS
	SELECT	@RateStruct = NULLIF(@RateStruct, ''),
			@Ctgy1 = NULLIF(@Ctgy1, ''),
			@Ctgy2 = NULLIF(@Ctgy2, ''),
			@Ctgy3 = NULLIF(@Ctgy3, ''),
			@Ctgy4 = NULLIF(@Ctgy4, '')

	SELECT	process_as_rate_category
	  FROM	maestro_rate_combination
	 WHERE	rate_structure = @RateStruct
	   AND	maestro_rate_category_code1 = @Ctgy1
	   AND	maestro_rate_category_code2 = @Ctgy2
	   AND	maestro_rate_category_code3 = @Ctgy3
	   AND	maestro_rate_category_code4 = @Ctgy4













GO
