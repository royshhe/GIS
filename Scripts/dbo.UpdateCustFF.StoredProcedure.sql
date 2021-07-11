USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustFF]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateCustFF    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustFF    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustFF    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: UpdateCustFF
PURPOSE: To update a frequent flyer membership for the customer
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Customer
ENSURES: This plan is set as the preferred one for the customer
MOD HISTORY:
Name    Date        Comments
Don K	Dec 11 1998 set preferred plan for cust
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCustFF]
	@CustId Varchar(10),
	@OldFFPlanId Varchar(10),
	@NewFFPlanId Varchar(10),
	@MemberNumber Varchar(20),
	@UserName varchar(20)
AS
DECLARE @nCustId int,
	@nNewFFPlanId smallint,
	@nOldFFPlanId SmallInt

SELECT	@nCustId = Convert(Int, NULLIF(@CustId,'')),
	@nNewFFPlanId = Convert(Smallint,@NewFFPlanId),
	@nOldFFPlanId = Convert(Smallint,@OldFFPlanId)	
	
	IF @NewFFPlanId != @OldFFPlanId
		/* Disconnect from cust before changing PK */
		UPDATE	customer
		   SET	preferred_ff_plan_id = NULL,
			preferred_ff_member_number = NULL
		 WHERE	customer_id = @nCustId
		
	UPDATE 	Frequent_Flyer_Plan_Member
	SET	Frequent_Flyer_Plan_ID = @nNewFFPlanId,
		FF_Member_Number = @MemberNumber
	WHERE	Frequent_Flyer_Plan_ID = @nOldFFPlanId
	AND	Customer_ID = @nCustId

	/* Update Audit Info & preferred membership */
	Update
		Customer
	Set
		Last_Changed_By = @UserName,
		Last_Changed_On = getDate(),
		preferred_ff_plan_id = @nNewFFPlanId,
		preferred_ff_member_number = @MemberNumber
	Where
		Customer_ID = @nCustId
	RETURN 1













GO
