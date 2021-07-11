USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFraudCard]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeleteFraudCard]
	@CardNumber varchar(20)
AS
DELETE FROM fraud_credit_Cards
WHERE	Credit_Card_number = @CardNumber
	


GO
