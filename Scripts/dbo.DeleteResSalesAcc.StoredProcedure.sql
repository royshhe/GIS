USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteResSalesAcc]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.DeleteResSalesAcc    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResSalesAcc    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResSalesAcc    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResSalesAcc    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Reserved_Sales_Accessory table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteResSalesAcc] --'12','*'
	@ConfirmNum 	Varchar(10),
	@OldSalesAccId	Varchar(5)
AS
	IF @ConfirmNum = ''
		SELECT @ConfirmNum = NULL
	IF @OldSalesAccId = ''
		SELECT @OldSalesAccId = NULL
	IF @OldSalesAccId='*'
	  BEGIN
		DELETE	Reserved_Sales_Accessory
		WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	  END
	 ELSE
		DELETE	Reserved_Sales_Accessory
		WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
		AND	( Sales_Accessory_ID = Convert(SmallInt, @OldSalesAccId))

	RETURN @@ROWCOUNT
GO
