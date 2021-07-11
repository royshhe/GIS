USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResSalesAcc]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateResSalesAcc    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResSalesAcc    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResSalesAcc    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResSalesAcc    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Reserved_Sales_Accessory table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateResSalesAcc]
	@ConfirmNum 	Varchar(10),
	@OldSalesAccId	Varchar(5),
	@NewSalesAccId	Varchar(5),
	@Qty		Varchar(5)
AS
	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @OldSalesAccId = ""
		SELECT @OldSalesAccId = NULL
	IF @NewSalesAccId = ""
		SELECT @NewSalesAccId = NULL
	UPDATE 	Reserved_Sales_Accessory
	SET 	Sales_Accessory_ID = Convert(SmallInt, @NewSalesAccId),
		Quantity = Convert(SmallInt, @Qty)
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	AND	Sales_Accessory_ID = Convert(SmallInt, @OldSalesAccId)
	RETURN @@ROWCOUNT













GO
