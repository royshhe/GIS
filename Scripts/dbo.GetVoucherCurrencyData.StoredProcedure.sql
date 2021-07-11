USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVoucherCurrencyData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetVoucherCurrencyData] -- 'B-01 YVR Airport'
	@Location varchar(35)
AS

	/* 2/22/99 - cpy created - copied from GetCurrencyData
			- get currency data based on 'Voucher Currency' in
			  lookup instead of 'Currency' */
	/* 3/01/99 - cpy bug fix - take Cdn,Us$ out from Voucher Currency,
			Added distinct */

--Select	Distinct
--	LT.Value,
--	LT.Code,
--	ISNULL(LER.Rate, ER.Rate)
--From
--	Exchange_Rate ER
--	Location L,
--	Lookup_Table LT,
--	
--	
--	Location_Exchange_Rate LER,
--Where
--	LT.Category IN ('Currency', 'Voucher Currency')
--	And L.Location = @Location
--	And Convert(tinyint, LT.Code) *= LER.Currency_ID
--	And L.Location_ID *= LER.Location_ID
--	And getDate() Between LER.Valid_From And ISNULL(LER.Valid_To, getDate())
--	And ER.Currency_ID = Convert(tinyint,LT.Code)
--	And getDate() Between ER.Exchange_Rate_Valid_From And ISNULL(ER.Valid_To,getDate())
--ORDER BY LT.Code








Select
	--LER.Location,
	LT.Value,
	LT.Code,
	ISNULL(LER.Rate, ER.Rate)
From
	Lookup_Table LT 
Inner Join Exchange_Rate ER
	On   Convert(tinyint,LT.Code) =  ER.Currency_ID 	
Left Join
   (
	Select L.Location, Lex.Rate, Lex.Currency_ID   from 
	Location L Left Join Location_Exchange_Rate  Lex
	On L.Location_ID = Lex.Location_ID	And getDate() Between Lex.Valid_From And ISNULL(Lex.Valid_To, getDate())
	Where L.Location =@Location  --'B-01 YVR Airport'   
				 
    ) LER
	On 	Convert(tinyint, LT.Code) = LER.Currency_ID	  
     
    		
Where
   LT.Category IN ('Currency', 'Voucher Currency')
	And getDate() Between ER.Exchange_Rate_Valid_From And ISNULL(ER.Valid_To,getDate())


Return 1
GO
