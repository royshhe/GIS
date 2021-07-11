USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateFreqFlyerMember]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateFreqFlyerMember    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateFreqFlyerMember    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateFreqFlyerMember    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: UpdateFreqFlyerMember
PURPOSE: To create or update a customer's membership in a frequent flyer plan
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Maestro
ENSURES: a record exists with the requested fields and it has been selected
	as the customer's preferred plan.
MOD HISTORY:
Name    Date        Comments
Don K	Dec 11 1998 set preferred plan
*/
CREATE PROCEDURE [dbo].[UpdateFreqFlyerMember]
	@FreqFlyerPlanId Varchar(5),
	@CustId Varchar(10),
	@MemberNum Varchar(20)
AS
DECLARE @iFreqFlyerPlanId SmallInt
DECLARE @iCustId Int
	SELECT 	@iFreqFlyerPlanId = Convert(SmallInt, NULLIF(@FreqFlyerPlanId,"")),
		@iCustId = Convert(Int, NULLIF(@CustId,""))
	SELECT @MemberNum = NULLIF(@MemberNum,"")
	/* connect the requested membership if it exists */
	UPDATE	Frequent_Flyer_Plan_Member
	SET	Customer_Id = @iCustId
	WHERE	Frequent_Flyer_Plan_Id = @iFreqFlyerPlanId
	AND	FF_Member_Number = @MemberNum
	/* otherwise create a new one. */
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO Frequent_Flyer_Plan_Member
			(frequent_flyer_plan_id,
			 customer_id,
			 ff_member_number)
		VALUES	(@iFreqFlyerPlanId,
			 @iCustId,
			 @MemberNum)
	END
	/* Update preferred plan */
	Update
		Customer
	Set
		preferred_ff_plan_id = @iFreqFlyerPlanId,
		preferred_ff_member_number = @MemberNum
	Where
		Customer_ID = @iCustId
	RETURN @@ROWCOUNT












GO
