USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOptExtra]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetResOptExtra    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtra    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtra    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtra    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResOptExtra]    --'B', '2011-03-25'
	@VehClassCode Varchar(1),
	@CurrDate Varchar(24)
AS
DECLARE @dCurrDatetime Datetime
DECLARE @dLastDatetime Datetime

	IF @VehClassCode = '' 	SELECT @VehClassCode = NULL

	SELECT 	@dCurrDatetime = Convert(Datetime, NULLIF(@CurrDate,'')),
		@dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')

	SELECT	A.Optional_Extra, A.Optional_Extra_ID,
		B.Daily_Rate, B.Weekly_Rate, '1', '',
		CONVERT(Varchar(10), C.LDW_Deductible) LDW_Deductible, A.Type,
		A.Maximum_Quantity,
		CONVERT(int, B.gst_exempt) HST_Exempt,
		CONVERT(int, B.HST2_exempt)HST2_Exempt,
		CONVERT(int, B.pst_exempt) PST_exempt,
		case when @CurrDate between OEC.Effective_Date and OEC.Termination_date
				then OEC.Coupon_Code
				else Null
		end Coupon_Code,
		case when @CurrDate between OEC.Effective_Date and OEC.Termination_date
				then OEC.Description
		end Description



FROM	
		Optional_Extra A
	Inner Join 	Optional_Extra_Price B
		  On A.Optional_Extra_ID = B.Optional_Extra_ID
	Left Join 	LDW_Deductible C
		 On A.Optional_Extra_ID = C.Optional_Extra_ID AND	C.Vehicle_Class_Code = @VehClassCode
	left join Optional_Extra_Coupon OEC on A.optional_extra_id=OEC.optional_extra_id

--
--	FROM	
--
--
--		Optional_Extra A
--		Optional_Extra_Price B,
--		LDW_Deductible C,
--		
	WHERE	A.Optional_Extra_ID NOT IN (
			SELECT	Optional_Extra_ID
			FROM	Optional_Extra_Restriction
			WHERE	Vehicle_Class_Code = @VehClassCode)
--	AND	A.Optional_Extra_ID *= C.Optional_Extra_ID
--	AND	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	A.Delete_Flag = 0
	AND	@dCurrDatetime BETWEEN B.Optional_Extra_Valid_From
 		    AND ISNULL(B.Valid_To, @dLastDatetime)
	
	ORDER BY C.LDW_Deductible, A.Optional_Extra
	RETURN @@ROWCOUNT
GO
