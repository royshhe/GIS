USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetChargeParameter]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*
PURPOSE: 	To retrieve the charge parameter for the given category..
MOD HISTORY:
Name    Date        Comments
*/
/* updated to ver 80 */

CREATE PROCEDURE [dbo].[GetChargeParameter]   --'Charge Type Adjustment'
	@Category varchar(25),
	@Code varchar(20) ='' -- null
AS
	Set Rowcount 2000
if @Category= 'Charge Type Manual'

	Select	Distinct
		LT.Value,
		LT.Code,
		Convert(Char(1), CP.Location_Fee),
		Convert(Char(1), CP.License_Fee),
		Convert(Char(1), convert(int,cp.HST_Exempt)*convert(int,cp.HST2_Exempt)) as GST_Exempt,--GST
		Convert(Char(1), CP.PST_Exempt) as PST_Exempt,--PST
		Convert(Char(1), CP.HST_Incl),
		Convert(Char(1), CP.PST_Incl)
		
	From
		Lookup_Table LT,
		Charge_Parameter CP

	Where	LT.Code = CP.Charge_Type
	And	LT.Category=@Category
	And 	LT.Code Like @Code + '%'
	And LT.Code <>'68'


	Order By
		Value
Else

   Select	Distinct
		LT.Value,
		LT.Code,
		Convert(Char(1), CP.Location_Fee),
		Convert(Char(1), CP.License_Fee),
		Convert(Char(1), convert(int,cp.HST_Exempt)*convert(int,cp.HST2_Exempt)) as GST_Exempt,--GST
		Convert(Char(1), CP.PST_Exempt) as PST_Exempt,--PST
		Convert(Char(1), CP.HST_Incl),
		Convert(Char(1), CP.PST_Incl)
		
	From
		Lookup_Table LT,
		Charge_Parameter CP

	Where	LT.Code = CP.Charge_Type
	And	LT.Category=@Category
	And 	LT.Code Like @Code + '%'
   
	Order By
		Value


Return 1
GO
