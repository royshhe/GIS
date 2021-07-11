USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContractAM]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[UpdateContractAM]
	@ContractNum	Varchar(10),	
	@FreqFlyerPlanId	Varchar(5),	
	@LastUpdateBy		Varchar(20),
	--@LastUpdateDate		Varchar(24),
	@FFMemberNum		Varchar(20),	
	@AMCouponCode		VarChar(25)
AS
	
DECLARE	@iContractNum Int



SELECT	@iContractNum =	CONVERT(int, NULLIF(@ContractNum,''))


UPDATE	Contract	SET	
	Frequent_Flyer_Plan_ID	= CONVERT(smallint, NULLIF(@FreqFlyerPlanId,'')),	
	FF_Member_Number	= NULLIF(@FFMemberNum,''),
    FF_Assigned_Date	= getdate(),
	Last_Update_By		= NULLIF(@LastUpdateBy,''),
	Last_Update_On		= getdate(),
	AM_Coupon_Code		=NULLIF(@AMCouponCode,'')
	
WHERE	Contract_Number	= @iContractNum and FF_Member_Number is  null
	RETURN @iContractNum


GO
