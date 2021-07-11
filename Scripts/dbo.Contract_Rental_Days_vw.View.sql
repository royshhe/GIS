USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Rental_Days_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Rental_Days_vw]
AS
SELECT     
	Contract_Number, 
	CONVERT(decimal(5,2),

		SUM(
		
			CONVERT(decimal(5,2),Quantity)*
			(
				CASE
					WHEN  Unit_Type='Day' then 1.00 
					WHEN  Unit_Type='Week' then 7.00 
					WHEN  Unit_Type='Month' then 30.00 
					WHEN  Unit_Type='Hour' then 1.00/3.00 
					WHEN  Unit_Type in ('AM', 'PM','OV') then 1.00/3.00
					ELSE 0	
				END
			)*
			(	
				
				CASE
					WHEN  Amount>=0 then 1.00 
					WHEN  Amount<0 then -1.00 
					--ELSE 0.00
				END
			) 
			
		)
		
	)	
	AS Rental_Day		

FROM         dbo.Contract_Charge_Item WITH(NOLOCK) 
where Charge_Type='10' AND Charge_Item_Type='c' --and contract_number>1000000
GROUP BY Contract_Number
GO
