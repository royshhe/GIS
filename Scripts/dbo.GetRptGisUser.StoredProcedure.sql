USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptGisUser]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptOperator
PURPOSE: To retrieve a list of operators (users)
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
Don K	Jun 29 1999 Get names from business_transaction instead of
		reservation history. Add flags to include reservations,
		contracts, or sales contracts
Sli	Aug 17 2005 Add one more parameter for filtering terminated operators		
*/
CREATE PROCEDURE [dbo].[GetRptGisUser]-- '*','1'
	@Group_name		varchar(50) = '*',
	@ActiveOpr  char(1)='1'
AS
	DECLARE	@bActiveOpr	bit
	IF @ActiveOpr <> ''  SELECT @bActiveOpr = CAST(NULLIF(@ActiveOpr, '') AS bit)
	

	SELECT	UG.User_Name,
			UG.user_id
--select *			
	FROM   GISUserGroupMain_vw UG inner join gisusers U on ug.user_id=u.user_id
where (U.active=@bActiveOpr   or u.user_name in ( 'Jessica Chen','Prajeet Didden','Wissam Itani'))
		and (@Group_name='*' or ug.Group_Name=@Group_name)
	order by UG.User_Name



















GO
