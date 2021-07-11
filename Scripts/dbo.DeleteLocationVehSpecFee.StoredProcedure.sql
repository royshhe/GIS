USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteLocationVehSpecFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================



create PROCEDURE [dbo].[DeleteLocationVehSpecFee]
	@VehSpecFeeID varchar(5)
AS
	DELETE FROM LocationVC_Specific_Fee
	WHERE LocationVC_Specific_Fee_ID = @VehSpecFeeID
GO
