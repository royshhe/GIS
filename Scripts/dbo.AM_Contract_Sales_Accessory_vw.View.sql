USE [GISData]
GO
/****** Object:  View [dbo].[AM_Contract_Sales_Accessory_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[AM_Contract_Sales_Accessory_vw]
AS
SELECT  cci.Contract_Number, 	
	SUM(cci.Amount - cci.GST_Amount_Included - cci.PST_Amount_Included - cci.PVRT_Amount_Included) AS Amount,
 	--bt.RBR_Date, --bt.Transaction_Date,
 	dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date
FROM    dbo.Contract_Charge_Item cci WITH(NOLOCK)  INNER JOIN
                      dbo.Business_Transaction bt WITH(NOLOCK) ON cci.Business_Transaction_ID = bt.Business_Transaction_ID INNER JOIN
                      dbo.AM_CheckIn_RBR_Date WITH(NOLOCK)  ON cci.Contract_Number = dbo.AM_CheckIn_RBR_Date.Contract_Number AND 
                      bt.RBR_Date <= dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date + 1 
WHERE     (cci.Charge_Type IN (

								SELECT  Code
								FROM          dbo.Lookup_Table WITH(NOLOCK) 
								WHERE      (Category LIKE '%charge type%') AND (Value LIKE '%Accessory%')
						)
			)
GROUP BY cci.Contract_Number, --bt.RBR_Date,--bt.Transaction_Date,  
dbo.AM_CheckIn_RBR_Date.Checkin_RBR_Date
GO
