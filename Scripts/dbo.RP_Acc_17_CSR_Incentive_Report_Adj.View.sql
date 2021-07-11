USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_17_CSR_Incentive_Report_Adj]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		CREATE View [dbo].[RP_Acc_17_CSR_Incentive_Report_Adj]
		
		as
		
		SELECT bt.RBR_Date as AdjRBRDate,CIBT.RBR_Date as CheckInRBRDate, WOC.User_ID,cci.Charge_Type, ChargeType.Value AS Charge_Description, cci.Amount as Amount_adj
		FROM  dbo.Contract_Charge_Item AS cci WITH (NOLOCK) 
		Inner Join (
		Select c.Contract_number, 
		Walk_Up = 
			(CASE 
				WHEN (c.Confirmation_Number is not null )
					THEN 0
				ELSE 1
				END
			)
			From dbo.Contract c
		)con
		On cci.Contract_number=con.Contract_number

		INNER JOIN
			   (SELECT Category, Code, Value, Alias, Editable
				FROM   dbo.Lookup_Table
				WHERE (Category LIKE '%charge type adj%')) AS ChargeType 
			 ON cci.Charge_Type = ChargeType.Code 
		 INNER JOIN dbo.Business_Transaction AS bt ON cci.Contract_Number = bt.Contract_Number 
				   AND cci.Business_Transaction_ID = bt.Business_Transaction_ID       
		INNER JOIN dbo.RP__CSR_Who_Opened_The_Contract WOC 
				   ON cci.Contract_Number = WOC.Contract_Number
		  INNER JOIN dbo.Business_Transaction CIBT 
				   ON cci.Contract_Number = CIBT.Contract_Number and CIBT.Transaction_Description = 'check in'
		  
		WHERE --(cci.Contract_Number = 1653350) 
				   --AND 
				   (cci.Charge_Item_Type = 'a') 
				   AND (cci.Charge_Type IN ('10','52','14', '20','21', '23', '34', '36', '37','47', '61', '62', '63', '64', '67', '68', '76','89', '98' )) 
				AND (bt.RBR_Date >= '2013-10-01') AND (bt.RBR_Date < '2013-11-01')
				And (CIBT.RBR_Date<'2013-10-01')
     --Group by  WOC.User_ID, ChargeType.Value
     --order by WOC.User_ID, ChargeType.Value 
     
 
      
GO
