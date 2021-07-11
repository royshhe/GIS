USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctFreqFlyMember]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PROCEDURE NAME: GetCtrctFreqFlyMember
PURPOSE: To retrieve a customer's Frequent Flyer Plan Member number
AUTHOR: Don Kirkby
DATE CREATED: Aug 11, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns the customer's member number in the given plan.
MOD HISTORY:
Name    Date        Comments
Don K	Nov 3 1998  Renamed member_number to ff_member_number
		    The whole thing needs to be rewritten for the new PK
Linda Qu Nov 14 2001 Disable the process to retrive unused the ff member info
                    to improve performance. 
		    
*/
--DROP PROCEDURE GetCtrctFreqFlyMember
--GO
CREATE PROCEDURE [dbo].[GetCtrctFreqFlyMember]
	@FreqFlyPlanId varchar(6),
	@CustId varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iFreqFlyPlanId SmallInt,
	@iCustId Int

	SELECT 	@iFreqFlyPlanId = CONVERT(smallint, NULLIF(@FreqFlyPlanId, '')),
		@iCustId = CONVERT(int, NULLIF(@CustId, ''))
	IF @iCustID is not null
	BEGIN

		SELECT	ff_member_number
	  	FROM	frequent_flyer_plan_member
	 	WHERE	frequent_flyer_plan_id = @iFreqFlyPlanId
	   	AND	customer_id = @iCustId
		RETURN @@ROWCOUNT
	END 
	ELSE 
	BEGIN 
		IF @iFreqFlyPlanId is null RETURN 0
		ELSE RETURN 200
	END











GO
