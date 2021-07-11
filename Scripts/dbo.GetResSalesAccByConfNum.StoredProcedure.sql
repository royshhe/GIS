USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResSalesAccByConfNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResSalesAccByConfNum]

	@ConfirmNum Varchar(20)
AS
	IF @ConfirmNum = ""	SELECT @ConfirmNum = NULL
	SELECT	Sales_Accessory_Id, Sales_Accessory_Id, Quantity
	FROM	Reserved_Sales_Accessory
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	RETURN @@ROWCOUNT












GO
