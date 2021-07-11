USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetUpgradeCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[GetUpgradeCharge]
AS
	/* 3/30/99 - cpy created - return upgrade charge ordered numerically */
	/* 4/05/99 - cpy modified - apply format mask to value */

	Select 	Convert(Varchar(20), Convert(Decimal(9,2), Value)), Code
	From	Lookup_Table
	Where	Category = 'Upgrade Charge'
	Order By Convert(Decimal(9,2), Value)

	Return @@ROWCOUNT











GO
