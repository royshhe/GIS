USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateFraudCard]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[CreateFraudCard]
	@CardNumber varchar(20),
	@CardType varchar(10),
	@Expiry varchar(10),
	@LastName varchar(40),
	@FirstName varchar(40)
AS
DECLARE @sExpiry As varchar(5)
Select @sExpiry =  substring(@Expiry, 1, 2) + '/' + substring(@Expiry, 3, 2)
INSERT INTO 	fraud_credit_Cards
		(Credit_Card_Number,
		Credit_Card_Type_ID,
		Expiry,
		Last_Name,
		First_Name)
VALUES	(@CardNumber,
		@CardType,
		@sExpiry,
		@LastName,
		@FirstName)
GO
