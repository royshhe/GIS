USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateFraudCard]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateFraudCard]
	@CardNumber varchar(20),
	@CardType varchar(20),
	@Expiry varchar(10),
	@LastName varchar(40),
	@FirstName varchar(40)
AS

UPDATE fraud_credit_Cards
SET	Credit_Card_Type_ID = @CardType,
	Expiry = @Expiry,
	Last_Name = @LastName,
	First_Name = @FirstName
WHERE Credit_Card_Number = @CardNumber


GO
