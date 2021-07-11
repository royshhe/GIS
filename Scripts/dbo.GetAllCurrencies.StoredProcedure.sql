USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCurrencies]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllCurrencies    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllCurrencies    Script Date: 2/16/99 2:05:40 PM ******/
/*
PROCEDURE NAME: GetAllCurrencies
PURPOSE: To list lookup table data of type 'Currency' and
	'Voucher Currency'
AUTHOR: Don Kirkby
DATE CREATED: Feb 9, 1999
CALLED BY: Exchange Rate
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllCurrencies]
AS
Select Value,Code
From
	Lookup_Table
Where
	Category IN ('Currency', 'Voucher Currency')
Order By Value
Return 1












GO
