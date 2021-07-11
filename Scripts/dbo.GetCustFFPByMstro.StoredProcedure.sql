USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustFFPByMstro]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCustFFPByMstro    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFFPByMstro    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFFPByMstro    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCustFFPByMstro    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCustFFPByMstro
PURPOSE: To retrieve the Frequent Flyer Plan id for a maestro code.
AUTHOR: Don Kirkby
DATE CREATED: Oct 22, 1998
CALLED BY: Customer
MOD HISTORY:
Name    Date        Comments
Don K	Feb 26 1999 Changed to search by Member Number instead of customer id.
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCustFFPByMstro]  -- 'ML',  '890034502751'
	@MstroCode	varchar(2),
	@MemberNum	varchar(20)
AS
	SELECT	@MstroCode = NULLIF(@MstroCode, '')
	SELECT	@MemberNum = NULLIF(@MemberNum, '')

	SELECT	ffp.frequent_flyer_plan_id,
		ffpm.ff_member_number
	  FROM	frequent_flyer_plan ffp Left Join  -- Use Inner Join instead of Left Join  - rhe
		frequent_flyer_plan_member ffpm
		On ffp.frequent_flyer_plan_id = ffpm.frequent_flyer_plan_id AND	ffpm.ff_member_number = @MemberNum
	 WHERE	ffp.maestro_code = @MstroCode
	   --AND	ffp.frequent_flyer_plan_id *= ffpm.frequent_flyer_plan_id
	   
	RETURN @@ROWCOUNT



--select * from ff_member_number
--select * from frequent_flyer_plan
GO
