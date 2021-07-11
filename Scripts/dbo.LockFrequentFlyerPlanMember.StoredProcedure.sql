USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockFrequentFlyerPlanMember]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Frequent_Flyer_Plan_Member for a contract
AUTHOR: Niem Phan
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockFrequentFlyerPlanMember]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Contract AS CON WITH(UPDLOCK)
	JOIN		Frequent_Flyer_Plan_Member AS FFPM WITH(UPDLOCK)
	ON		CON.Frequent_Flyer_Plan_ID = FFPM.Frequent_Flyer_Plan_ID

	 WHERE	CON.contract_number = @nCtrctNum











GO
