USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteLocationSpecFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[DeleteLocationSpecFee]
	@SpecID varchar(5)
AS
	DELETE FROM Location_Specific_Fees
	WHERE Spec_Fee_ID = @SpecID



GO
