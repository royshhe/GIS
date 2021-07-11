USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetChargeableParameter]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: 	To retrieve the charge parameter for the given category..
MOD HISTORY:
Name    Date        Comments
Roy He  2006-03-03
*/
/* updated to ver 80 */

CREATE PROCEDURE [dbo].[GetChargeableParameter]
	@Category varchar(25),
	@Code varchar(20) ='' -- null
AS
	Set Rowcount 2000

	Select	Distinct
		--LT.Value,
		LT.Code,
		Chargeable_Type
	From
		Lookup_Table LT,
		Chargeable_Parameter CP

	Where	LT.Code = CP.Charge_Type
	And	LT.Category=@Category
	And 	LT.Code Like @Code + '%'


	--Order By
		--Value

Return 1

GO
