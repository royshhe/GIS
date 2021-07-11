USE [GISData]
GO
/****** Object:  View [dbo].[Contract_ClaimCharge_Sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*------------------------------------------------------------------------------------------------------------------
	Programmer:	Roy He
	Date:		27 Feb 2002
	Details		Sum all items, seperate in different columns (Summary)
	Modification:		Name:		Date:		Detail:

-------------------------------------------------------------------------------------------------------------------

*/
CREATE VIEW [dbo].[Contract_ClaimCharge_Sum_vw]
AS
	SELECT      
			RBR_Date, 
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
	FROM         dbo.Contract_Charge_vw WITH (NOLOCK)
	GROUP BY RBR_Date,Contract_Number


GO
