USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdhocOpenContractReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Aug 16, 2001
--  Details: 	 ad hoc report for open status contracts
--  Tracker:	 Issue# 1868
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetAdhocOpenContractReport]

 AS

SELECT  con.contract_number , 
        loc.location ,
        bt.Transaction_Date as 'Open Date',
        con.Pick_Up_On 
FROM Contract con
join location loc
 on con.Pick_Up_Location_ID = loc.location_id
left join business_transaction bt
  on con.contract_number = bt.contract_number and bt.transaction_description = 'Open'
WHERE 
	con.status = 'OP'

order by con.Pick_Up_Location_ID , bt.Transaction_Date , con.contract_number

COMPUTE COUNT(con.contract_number) by con.Pick_Up_Location_ID


GO
