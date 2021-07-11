USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCustFF]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateCustFF    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CreateCustFF    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCustFF    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateCustFF
PURPOSE: To create a new frequent flyer membership for the customer
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Customer
ENSURES: This membership is set as the preferred one for the customer
MOD HISTORY:
Name    Date        Comments
Don K	Dec 11 1998 set customer's preferred membership
*/
CREATE PROCEDURE [dbo].[CreateCustFF]
	@CustId 	Varchar(10),
	@FFPlanId 	Varchar(5),
	@MemberNumber 	Varchar(20),
	@UserName 	varchar(20)
AS
DECLARE @nCustId int,
	@nFFPlanId smallint
SELECT	@nCustId = Convert(Int, NULLIF(@CustId,'')),
	@MemberNumber = NULLIF(@MemberNumber,""),
	@nFFPlanId = Convert(smallInt, NULLIF(@FFPlanId,""))
	INSERT INTO Frequent_Flyer_Plan_Member
		(Frequent_Flyer_Plan_ID,
		 FF_Member_Number,
		 Customer_ID)
	VALUES
		(@nFFPlanId,
		 @MemberNumber,
		 @nCustId)
	/* Update Audit Info & preferred plan */
	Update
		Customer
	Set
		Last_Changed_By = @UserName,
		Last_Changed_On = getDate(),
		preferred_ff_plan_id = @nFFPlanId,
		preferred_ff_member_number = @MemberNumber
	Where
		Customer_ID = @nCustId
	RETURN 1
GO
