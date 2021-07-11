USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCurrencyData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCurrencyData    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetCurrencyData    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCurrencyData    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCurrencyData    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the currency exchange rate for the given location.
     MOD HISTORY:
     Name    Date        Comments
	 Roy He	2011		Upgrade to MS sql 2008
*/
CREATE PROCEDURE [dbo].[GetCurrencyData] -- 'B-01 YVR Airport'
@Location varchar(35)
AS
--Select
--	LT.Value,
--	LT.Code,
--	ISNULL(LER.Rate, ER.Rate)
--From
--	Lookup_Table LT,
--	Location_Exchange_Rate LER,
--	Location L, Exchange_Rate ER
--Where
--	LT.Category = 'Currency'
--	And L.Location = @Location
--	And Convert(tinyint, LT.Code) *= LER.Currency_ID
--	And L.Location_ID *= LER.Location_ID
--	And getDate() Between LER.Valid_From And ISNULL(LER.Valid_To, getDate())
--	And ER.Currency_ID = Convert(tinyint,LT.Code)
--	And getDate() Between ER.Exchange_Rate_Valid_From And ISNULL(ER.Valid_To,getDate())
--Return 1



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
   LT.Category = 'Currency'	
	And getDate() Between ER.Exchange_Rate_Valid_From And ISNULL(ER.Valid_To,getDate())


Return 1
--
--Select
--	L.location,
--	LT.Value,
--	LT.Code,
--	ISNULL(LER.Rate, ER.Rate)
--From
--	Lookup_Table LT,
--	Location_Exchange_Rate LER,
--	Location L, Exchange_Rate ER
--Where
--	LT.Category = 'Currency'
--	And L.Location = 'B-01 YVR Airport'
--	And Convert(tinyint, LT.Code) *= LER.Currency_ID
--	And L.Location_ID *= LER.Location_ID
--	And getDate() Between LER.Valid_From And ISNULL(LER.Valid_To, getDate())
--	And ER.Currency_ID = Convert(tinyint,LT.Code)
--	And getDate() Between ER.Exchange_Rate_Valid_From And ISNULL(ER.Valid_To,getDate())
--
--
GO
