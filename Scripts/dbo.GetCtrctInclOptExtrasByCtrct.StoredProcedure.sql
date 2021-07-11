USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctInclOptExtrasByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/*
PROCEDURE NAME: GetCtrctInclOptExtrasByCtrct
PURPOSE: To retrieve all optional extras for a contract
	that are included in the rate
	except coverages.
AUTHOR: Don Kirkby
DATE CREATED: Aug 28, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns the optional extras with details
MOD HISTORY:
Name    Date         Comments
CPY     Mar 11 1999  Return 0/1 instead of N/Y for Included_In_Rate
*/

CREATE PROCEDURE [dbo].[GetCtrctInclOptExtrasByCtrct]
	@RateId			varchar(11),
	@VehicleClassCode	varchar(1),
	@RentFromDate		varchar(12),
	@RentFromTime		varchar(6),
	@RentToDate		varchar(12),
	@RentToTime		varchar(6),
	@CtrctNum		varchar(11)
AS
	/* 3/11/99 - cpy modified - Return 0/1 instead of N/Y for Included_In_Rate  */
	/* 10/14/99 - do type conversion and nullif outside of SQL statement */

	DECLARE	@dRentFrom	datetime, 
		@iRateId	Int,
		@iCtrctNum	Int

	SELECT	@dRentFrom =
		CASE WHEN @RentFromDate = '' THEN
		  NULL
		ELSE
		  CONVERT(datetime, @RentFromDate + ' ' + @RentFromTime)
		END, 
		@iRateId = CONVERT(int, NULLIF(@RateId, '')), 
		@iCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
		
	SELECT	oeo.optional_extra,
		oeo.optional_extra_id,
		ioe.quantity included_qty,
		ISNULL(coe.quantity, 0) qty,
		CASE coe.optional_extra_id
		  WHEN NULL THEN '0'	-- previously 'N'
		  ELSE '1'		-- previously 'Y'
		END coe_exists,
		ISNULL(CONVERT(varchar, coe.rent_from, 106),
			@RentFromDate) rent_from_date,
		ISNULL(CONVERT(varchar(5), coe.rent_from, 8),
			@RentFromTime) rent_from_time,
		ISNULL(CONVERT(varchar, coe.rent_to, 106),
			@RentToDate) rent_to_date,
		ISNULL(CONVERT(varchar(5), coe.rent_to, 8),
			@RentToTime) rent_to_time,		
		coe.Unit_Number,
		oeo.type
	  FROM	 optional_extra_other oeo
		Inner Join	contract_optional_extra coe
				 On 	oeo.optional_extra_id =coe.optional_extra_id 
       Inner Join	included_optional_extra ioe
				 On  oeo.optional_extra_id = ioe.optional_extra_id 
	 

--
--       optional_extra_other oeo,
--		contract_optional_extra coe,
--		included_optional_extra ioe
	 WHERE
--         	ioe.optional_extra_id = oeo.optional_extra_id	   AND	
		ioe.rate_id = @iRateId
	   AND (@dRentFrom	BETWEEN	ioe.effective_date    AND	ioe.termination_date)
	   AND	oeo.optional_extra_id NOT IN
			(
			SELECT	optional_extra_id
			  FROM	optional_extra_restriction
			 WHERE	vehicle_class_code = @VehicleClassCode
			)
--	   AND	coe.optional_extra_id =* oeo.optional_extra_id
	   AND	coe.contract_number = @iCtrctNum
	   AND	coe.included_in_rate = '1'		-- previously 'Y'
	   AND	coe.termination_date = '31 Dec 2078 23:59'
	 ORDER
	    BY	oeo.optional_extra
	RETURN @@ROWCOUNT
GO
