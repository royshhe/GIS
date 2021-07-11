USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateFreqFlyerMember]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To insert a record into Frequent_Flyer_Plan_Member table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateFreqFlyerMember]
	@FreqFlyerPlanId Varchar(5),
	@MemberNum Varchar(20),
	@CustId Varchar(10)
AS
DECLARE @iFreqFlyerPlanId SmallInt
DECLARE @iCustId Int
DECLARE @iCount Int

	SELECT 	@iFreqFlyerPlanId = Convert(SmallInt, NULLIF(@FreqFlyerPlanId,"")),
		@iCustId = Convert(Int, NULLIF(@CustId,"")),
		@MemberNum = NULLIF(@MemberNum,"")

	/* check if frequent flyer member number already exists */
	SELECT	@iCount = Count(*)
	FROM	Frequent_Flyer_Plan_Member
	WHERE	Frequent_Flyer_Plan_Id = @iFreqFlyerPlanId
	AND	FF_Member_Number = @MemberNum

	/* if ff member# doesn't exist, create a new one */
	IF @iCount = 0 and @MemberNum is not null
	BEGIN
		INSERT INTO Frequent_Flyer_Plan_Member
			(frequent_flyer_plan_id,
			 customer_id,
			 ff_member_number)
		VALUES	(@iFreqFlyerPlanId,
			 @iCustId,
			 @MemberNum)
	END

	RETURN @@ROWCOUNT
GO
