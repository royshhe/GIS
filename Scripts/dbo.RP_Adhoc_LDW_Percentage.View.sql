USE [GISData]
GO
/****** Object:  View [dbo].[RP_Adhoc_LDW_Percentage]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[RP_Adhoc_LDW_Percentage]

AS
SELECT      
		
	RBR_Date, 	
	Pick_Up_Location_ID,
   	Contract_number,
           Contract_Rental_Days,	
	
           (case when
		SUM(Case When OptionalExtraType IN ('LDW') and  Amount>0 Then 1
			 When OptionalExtraType IN ('LDW') and  Amount<0 Then -1
			 ELSE 0
		         END
	              )>0 
	        Then 1
	       Else 0
            End)				as AllLevelLDWCount,




           (case when
		SUM(Case When OptionalExtraType IN ('BUYDOWN') and  Amount>0 Then 1
			 When OptionalExtraType IN ('BUYDOWN') and  Amount<0 Then -1
			 ELSE 0
		         END
	              )>0 
	        Then 1
	       Else 0
            End)				as BuyDownCount,



             (Case when	
	             SUM(Case When OptionalExtraType IN ('PAI','PAE') and  Amount>0 Then 1
			    When OptionalExtraType IN ('PAI','PAE') and  Amount<0 Then -1
			    ELSE 0
		          END
	             )>0 
		Then 1
		Else 0
	End)	as PAICount,
            
             (Case when	
		SUM(Case When OptionalExtraType IN ('PEC','RSN') and  Amount>0 Then 1
			     When OptionalExtraType IN ('PEC','RSN') and  Amount>0 Then -1			
			    ELSE 0
		          END
	             )>0 
		Then  1
		Else 0
	End)						as PECCount 


FROM 	RP_Acc_17_CSR_Incremental_Yield_L1 

GROUP BY 	RBR_Date,
		Pick_Up_Location_ID,
   		
		Contract_number,
		
		Contract_Rental_Days
GO
