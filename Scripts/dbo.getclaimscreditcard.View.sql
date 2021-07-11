USE [GISData]
GO
/****** Object:  View [dbo].[getclaimscreditcard]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
VIEW NAME: getclaimscreditcard
PURPOSE: Select credit card information based on contract number for CARS program

AUTHOR:	Junaid Ahmed
DATE CREATED: 2002 Feb 26
USED BY: Enter Vehicle Accident Screen

MOD HISTORY:
Name 		Date		Comments

*/


CREATE VIEW [dbo].[getclaimscreditcard]
AS
SELECT		dbo.Credit_Card.Credit_Card_Number, 
			dbo.Credit_Card.Credit_Card_Type_ID, 
			dbo.Credit_Card.Expiry, 
            dbo.Credit_Card_Authorization.Contract_Number
FROM         dbo.Credit_Card INNER JOIN
                      dbo.Credit_Card_Authorization ON dbo.Credit_Card.Credit_Card_Key = dbo.Credit_Card_Authorization.Credit_Card_Key
union

SELECT      dbo.Credit_Card_Transaction.Credit_Card_Number,
			dbo.Credit_Card_Transaction.Credit_Card_Type_Id, 
			dbo.Credit_Card_Transaction.Expiry,
			dbo.Contract.Contract_Number
FROM         dbo.Credit_Card_Transaction INNER JOIN
                      dbo.Contract ON dbo.Credit_Card_Transaction.Contract_Number = dbo.Contract.Contract_Number


GO
