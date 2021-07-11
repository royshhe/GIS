USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Claim_Revenue_Sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[Contract_Claim_Revenue_Sum_vw]
as
SELECT  RBR_Date, 
contract_number,
             SUM( CASE 	WHEN Charge_Type IN (15)
			THEN Amount
			ELSE 0
		END)  
            								as DemageClaim,
	SUM( CASE 	WHEN Charge_Type IN (38)
			THEN Amount
			ELSE 0
		END)  
            								as DemageClaimAdmin,

	SUM( CASE 	WHEN Charge_Type IN (70)
			THEN Amount
			ELSE 0
		END)  
            								as LossOfUse
FROM Contract_Revenue_vw
GROUP BY RBR_Date,
	contract_number
	 
GO
