USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOptExtraByConfNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE PROCEDURE [dbo].[GetResOptExtraByConfNum] --'2184541'

	@ConfirmNum Varchar(20)
AS
	SELECT @ConfirmNum = NULLIF(@ConfirmNum,'')

	SELECT 	Optional_Extra_ID, Optional_Extra_ID, '', '', Quantity,'','',coupon,Flat_Rate,
			Description	
--select *
	FROM	Reserved_Rental_Accessory  
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	RETURN @@ROWCOUNT


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
