USE [GISData]
GO
/****** Object:  View [dbo].[Last_Vehicle_On_Contract_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
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

CREATE VIEW [dbo].[Last_Vehicle_On_Contract_vw]
AS
SELECT *
FROM Vehicle_On_Contract WITH(NOLOCK)
WHERE 
	(business_transaction_id = 
	(select max(voc1.business_transaction_id)
	from vehicle_on_contract voc1 WITH(NOLOCK)
	where voc1.contract_number = Vehicle_On_Contract.Contract_Number))





















GO
