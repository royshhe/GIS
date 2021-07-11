USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMemberDiscount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetMemberDiscount    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetMemberDiscount    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetMemberDiscount]
	@DiscountId Varchar(1)
AS
	SELECT	Percentage
	FROM	Discount
	WHERE	Discount_ID = @DiscountId
	RETURN @@ROWCOUNT












GO
