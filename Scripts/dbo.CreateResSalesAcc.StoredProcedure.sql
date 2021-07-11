USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResSalesAcc]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateResSalesAcc    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CreateResSalesAcc    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResSalesAcc    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResSalesAcc    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Reserved_Sales_Accessory table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateResSalesAcc]
	@ConfirmNum 	Varchar(10),
	@NewSalesAccId	Varchar(5),
	@Qty		Varchar(5)
AS
	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @NewSalesAccId = ""
		SELECT @NewSalesAccId = NULL
	INSERT INTO Reserved_Sales_Accessory
		(Confirmation_Number, Sales_Accessory_ID, Quantity)
	VALUES	(Convert(Int, @ConfirmNum),
		 Convert(SmallInt, @NewSalesAccId),
		 Convert(SmallInt, @Qty))
	RETURN @@ROWCOUNT













GO
