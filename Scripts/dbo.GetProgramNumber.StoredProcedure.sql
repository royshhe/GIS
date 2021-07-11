USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetProgramNumber]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[GetProgramNumber]
	@CustId Varchar(10)
AS
	SELECT	Program_Number

	FROM		Customer
	WHERE	Customer_ID = Convert(Int, @CustId)
	
	RETURN 1












GO
