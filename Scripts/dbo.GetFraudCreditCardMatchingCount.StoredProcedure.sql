USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetFraudCreditCardMatchingCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: GetFraudCreditCardMatchingCount
PURPOSE: Find the match of Frandelent Credit Card Record
	
AUTHOR:	Roy He
DATE CREATED: 2006/03/28
USED BY: Frandelent Credit Card detection (Main)
MOD HISTORY:
Name 		Date		Comments

*/

CREATE PROCEDURE [dbo].[GetFraudCreditCardMatchingCount]
	@CreditCardNumber varchar(20)
AS
SELECT    count(*) as CountNum
FROM         dbo.Fraud_Credit_Cards
where Credit_Card_Number = @CreditCardNumber

RETURN 1
GO
