USE [GISData]
GO
/****** Object:  View [dbo].[Contract_TnM_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[Contract_TnM_vw]
as
Select 	
	
    	c.Contract_Number, 
   	
	Amount = sum(cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included)
	
	
FROM 	Contract c WITH(NOLOCK)
	INNER JOIN
    	
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number	
WHERE 		
	c.Status = 'CI'
	and 
	cci.Charge_Type IN (10, 11, 20,50, 51, 52)
GROUP BY 	c.Contract_Number
		
	









GO
