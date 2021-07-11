USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractReferringEmployee]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the referring employee for a contract
AUTHOR: Cindy Yee
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractReferringEmployee]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	referring_employee RE,	--WITH(UPDLOCK), 
		contract C		WITH(UPDLOCK)
	 WHERE	C.contract_number = @nCtrctNum
	   AND	C.referring_employee_id = RE.referring_employee_id









GO
