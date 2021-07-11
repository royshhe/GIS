USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepositAmount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetResDepositAmount    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepositAmount    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResDepositAmount] 
	@ConfirmNum Varchar(10)
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iConfirmNum Int

	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

SELECT
	Sum(Amount)
From
	Reservation_Dep_Payment
WHERE
	Confirmation_Number = @iConfirmNum
	AND	Amount >= 0
	AND	Forfeited = 0
	AND 	Refunded = 0
GROUP BY Confirmation_Number

RETURN @@ROWCOUNT

















GO
