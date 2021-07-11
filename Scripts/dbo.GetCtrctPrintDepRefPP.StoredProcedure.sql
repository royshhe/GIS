USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintDepRefPP]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  PURPOSE:		To retrieve a list of cash payments and refunds for the given contract. 
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintDepRefPP] -- '3000709', 'cert' ,'1'
	@CtrctNum	VarChar(10),
	--@PPType Varchar(20),
	@BillingCopy as Varchar(1)='0'
AS
	/* 6/24/99 - created - copied from GetCtrctDepRefCA, but returns
			Cash_Payment_Type */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
DECLARE @CurrDate Datetime
DECLARE @RateId Int
DECLARE @RatePurpose VarChar(50)
DECLARE @bBillingCopy BIT

Select @bBillingCopy=CONVERT(bit, @BillingCopy)

	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

    -- Get contract PU Date; round to beginning of day
	SELECT 	@RateId=Rate_ID, @CurrDate=Rate_Assigned_Date 
	FROM	Contract
	WHERE	Contract_Number = @iCtrctNum

	If @RateId is not null
		SELECT 	@RatePurpose= RP.Rate_Purpose
		FROM	Vehicle_Rate VR,
				Rate_Purpose RP
		WHERE	VR.Rate_Id = Convert(Int, @RateId)
			AND	VR.Rate_Purpose_ID = RP.Rate_Purpose_ID
			AND	Convert(Datetime, @CurrDate)
			BETWEEN VR.Effective_Date AND VR.Termination_Date
	Else
		Select @RatePurpose=''

	--if (@RatePurpose<>'Tour Pkg' or (@bBillingCopy=1 and @RatePurpose ='Tour Pkg'))
	--	select @PPType='*'

	SELECT	PP.Payment_Type,
		CPI.Collected_At_Location_Id,
	
		PP.Foreign_Currency_Amt_Collected,
		PP.Currency_ID,

		PP.Exchange_Rate,
		CPI.Amount,
		PP.PP_Number,
		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113) AS Collected_On ,
       PP.Issuer_ID,
	   AM.Address_Name,
	   PP.PP_Number
      
 
	FROM	Prepayment PP Inner Join 
		Contract_Payment_Item CPI 
		On PP.Contract_Number=CPI.Contract_Number AND	CPI.Sequence = PP.Sequence
	    Inner Join Armaster AM On  PP.Issuer_ID=AM.Customer_Code
		 
	WHERE	PP.Contract_Number = @iCtrctNum
	        And
			(	PP.Payment_Type='Certificate' 	
				Or (PP.Payment_Type='VOUCHER' and  @RatePurpose<>'Tour Pkg')
				Or  (PP.Payment_Type='VOUCHER' and  @RatePurpose='Tour Pkg' and @bBillingCopy=1)
			)
	
			--AND(@PPType='*' or	PP.Payment_Type like @PPType+'%')
-- 
	ORDER BY PP.Payment_Type, Collected_On

	RETURN @@ROWCOUNT

--select * from prepayment where contract_number=3000106

--select * from armaster where address_name  like 'bc golf%'
GO
