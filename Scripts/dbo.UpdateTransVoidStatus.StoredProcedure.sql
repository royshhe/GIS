USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTransVoidStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateTransVoidStatus]
	@AuthNum 	Varchar(12),
	@CCTypeId 	Char(3),
	@CCNum 		Varchar(20),
	@LastName 	Varchar(25),
	@FirstName 	Varchar(25),
	@CCExpiry 	Char(5),
	@Amount 	Varchar(10),
	@ContractNum 	Varchar(10),
	@ConfirmNum 	Varchar(10),
	@SalesCtrctNum 	Varchar(10),
	@RBRDate 	Varchar(24)
AS
UPDATE	Credit_Card_Transaction
SET	Void = 1
WHERE	Authorization_Number = @AuthNum AND 
	Credit_Card_Type_id = @CCTypeId AND 
	Credit_Card_Number = @CCNum AND
	Last_Name = @LastName AND
	First_Name = @FirstName AND
	Expiry = @CCExpiry AND
	Amount = @Amount AND
	RBR_Date = @RBRDate


GO
