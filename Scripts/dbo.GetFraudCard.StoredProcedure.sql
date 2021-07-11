USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetFraudCard]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[GetFraudCard]
	@CardNumber varchar(20)
AS
SELECT 	Credit_Card_Number,
		Credit_Card_Type_ID,
		Expiry,
		Last_Name,
		First_Name
FROM		fraud_credit_Cards
WHERE	Credit_Card_number = @CardNumber


GO
