USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDeposit]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResDeposit    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResDeposit    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResDeposit]
	@VehClassCode Varchar(1)
AS
	IF @VehClassCode = ""	SELECT @VehClassCode = NULL
	SELECT	Deposit_Amount, Minimum_Cancellation_Notice
	FROM	Vehicle_Class
	WHERE	Vehicle_Class_Code = @VehClassCode
	RETURN @@ROWCOUNT












GO
