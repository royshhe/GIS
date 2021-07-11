USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDOLocOverlapDateRange]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetDOLocOverlapDateRange    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetDOLocOverlapDateRange    Script Date: 2/16/99 2:05:41 PM ******/
/*  
PURPOSE:		To retrieve the valid from and valid to date which overlap with the given @ValidFrom and @ValidTo.
MOD HISTORY:
Name    Date        Comments
Don K	27 Mar 2000 Do all date comparisons to the day
*/
CREATE PROCEDURE [dbo].[GetDOLocOverlapDateRange]
	@LocationID		VarChar(10),
	@DropOffLocationID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)
AS
	DECLARE	@dValidFrom	datetime,
		@dValidTo	datetime
	SELECT	@dValidFrom = CAST(FLOOR(CAST(CAST(NULLIF(@ValidFrom, '') AS datetime) AS float)) AS datetime),
		@dValidTo = CAST(FLOOR(CAST(CAST(NULLIF(@ValidTo, '') AS datetime) AS float)) AS datetime)

	SELECT	CONVERT(VarChar, Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111)
	FROM	Pick_Up_Drop_Off_Location
	WHERE	Pick_Up_Location_ID = CONVERT(SmallInt, @LocationID)
	AND	Drop_Off_Location_ID = CONVERT(SmallInt, @DropOffLocationID)
	AND	(  @dValidFrom BETWEEN Valid_From AND ISNULL(Valid_To, @dValidFrom)
		OR @dValidTo BETWEEN Valid_From AND ISNULL(Valid_To, @dValidTo)
		OR Valid_From BETWEEN @dValidFrom AND ISNULL(@dValidTo, Valid_From)
		)
	ORDER BY
		Valid_From DESC
RETURN 1














GO
