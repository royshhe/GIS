USE [GISData]
GO
/****** Object:  View [dbo].[Latest_credit_card]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP__Last_Vehicle_On_Contract
PURPOSE: Select last vehicle on a contract

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reporting Views
MOD HISTORY:
Name 		Date		Comments
*/

create VIEW [dbo].[Latest_credit_card]
AS
SELECT *
FROM credit_card WITH(NOLOCK)
WHERE 
	(credit_card_key = 
	(select max(cc.credit_card_key)
	from credit_card cc
	where cc.Credit_Card_Number = credit_card.Credit_Card_Number
			and cc.Expiry = credit_card.Expiry))
GO
