USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCustFF]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCustFF    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustFF    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustFF    Script Date: 1/11/99 1:03:15 PM ******/
/*
PROCEDURE NAME: DeleteCustFF
PURPOSE: To delete a frequent flyer membership for the customer
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Customer
MOD HISTORY:
Name    Date        Comments
Don K	Dec 11 1998 disconnect from customer's preferred membership
*/
CREATE PROCEDURE [dbo].[DeleteCustFF]
	@CustId Varchar(10),
	@OldFFPlanId Varchar(10),
	@MemberNumber Varchar(20),
	@UserName varchar(20)
AS
DECLARE @nPlanId smallint
SELECT	@nPlanId = Convert(smallint,@OldFFPlanId),
	@MemberNumber = NULLIF(@MemberNumber, '')
/* First Update Audit Info & disconnect any references from customers */
UPDATE	customer
   SET	preferred_ff_plan_id = NULL,
	preferred_ff_member_number = NULL,
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
 WHERE	preferred_ff_plan_id = @nPlanId
   AND	preferred_ff_member_number = @MemberNumber
/* then delete the membership */
DELETE
	Frequent_Flyer_Plan_Member
WHERE
	Frequent_Flyer_Plan_ID = @nPlanId
	AND	Customer_ID = Convert(Int,@CustId)
	AND	FF_Member_Number = @MemberNumber
RETURN 1












GO
