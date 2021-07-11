USE [GISData]
GO
/****** Object:  View [dbo].[RP__First_Contract_Credit_card_Using]    Script Date: 2021-07-10 1:50:45 PM ******/
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
create VIEW [dbo].[RP__First_Contract_Credit_card_Using]
AS
SELECT Contract_Number ,sum(Swiped_Flag) as Swiped_Flag  --,Collected_On 
from (
SELECT Contract_Number ,case when Swiped_Flag='1'then 1 else 0 end as Swiped_Flag ,Authorized_On as collected_on,sequence
FROM Credit_Card_Authorization WITH(NOLOCK)
union
SELECT ccp.Contract_Number,case when Swiped_Flag='1' then 1 else 0 end as Swiped_Flag, Collected_On ,ccp.sequence
	FROM Credit_Card_Payment CCP with (nolock)Inner Join 
		Contract_Payment_Item CPI with (nolock)
            On  CCP.Contract_Number=CPI.Contract_Number   And CCP.Sequence  = CPI.Sequence
) CC

WHERE (Collected_On  =
       (SELECT MIN(CC1.Collected_On)
     FROM (SELECT Contract_Number ,Swiped_Flag ,Authorized_On as collected_on
FROM Credit_Card_Authorization cca WITH(NOLOCK)
union
SELECT ccp1.Contract_Number,Swiped_Flag, Collected_On 
	FROM Credit_Card_Payment CCP1 with (nolock)Inner Join 
		Contract_Payment_Item CPI1 with (nolock)
            On  CCP1.Contract_Number=CPI1.Contract_Number   And CCP1.Sequence  = CPI1.Sequence) CC1
     WHERE cc1.contract_Number =cc.Contract_Number))   
     
 and sequence=0      
group by contract_number
GO
