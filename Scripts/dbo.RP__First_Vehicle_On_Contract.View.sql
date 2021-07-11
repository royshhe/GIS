USE [GISData]
GO
/****** Object:  View [dbo].[RP__First_Vehicle_On_Contract]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP__First_Vehicle_On_Contract
PURPOSE: Select first vehicle on a contract

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reporting Views
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP__First_Vehicle_On_Contract]
AS
SELECT *
FROM Vehicle_On_Contract WITH(NOLOCK)
WHERE (Checked_Out =
       (SELECT MIN(voc.Checked_out)
     FROM Vehicle_On_Contract voc
     WHERE voc.contract_Number = Vehicle_On_Contract.Contract_Number))
and 
	(business_transaction_id = 
	(select min(voc1.business_transaction_id)
	from vehicle_on_contract voc1
	where voc1.contract_number = Vehicle_On_Contract.Contract_Number))














GO
