USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_Payments]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--select * from Credit_card_Payment where contract_number=1303804
--
--select * from Credit_card where Credit_Card_Key in (1189648,
--1191551)


--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2008-01-10
--	Details		IRACS Submission
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
 CREATE PROCEDURE [dbo].[IRACS_GET_Payments]  --1341710
(
	@CtrctNumber varchar(20)
)
AS


SELECT    --dbo.Contract_Payment_Item.Contract_Number, 
	dbo.Contract_Payment_Item.Collected_On, 
	'8888' EmpID, --dbo.Contract_Payment_Item.Collected_By, 

	Case 
		when dbo.Business_Transaction.Transaction_Description='Adjustments' Then 'A'
		when dbo.Business_Transaction.Transaction_Description='Check Out' Then 'O'
		when dbo.Business_Transaction.Transaction_Description='Change' Then 'W'
		Else 'C'
	End PaySrc,

	Case 
		When dbo.Contract_Payment_Item.Payment_Type='Credit Card' Then 
		(Case When dbo.Credit_Card_Type.Maestro_Code in ('BL','GE','BO','BI','CP') Then 'BU'
		     Else dbo.Credit_Card_Type.Maestro_Code
		End)
		When dbo.Contract_Payment_Item.Payment_Type='A/R' Then 'DB'
 		When dbo.Contract_Payment_Item.Payment_Type='Cash' Then 'CS'
	End PayCode,
	dbo.CCMask(dbo.Credit_Card.Credit_Card_Number,4,4) AS PayNum, 
   (Case 
		when  dbo.Credit_Card.Expiry<>'__/__'  and dbo.Credit_Card.Expiry is not null And isNumeric(Substring(dbo.Credit_Card.Expiry,1,2))=1 and isNumeric( Substring(dbo.Credit_Card.Expiry,1,2)) =1 then 
			(Case When Substring(dbo.Credit_Card.Expiry,1,2) >=1 and Substring(dbo.Credit_Card.Expiry,1,2)<=12 Then
				DateAdd(m,1, Convert(Datetime,Substring(dbo.Credit_Card.Expiry,1,2)+'/'+'01/'+'20'+Substring(dbo.Credit_Card.Expiry,4,2)))-1 
			Else 
				Convert(Datetime, '2078-12-31')
			End)
		Else Convert(Datetime, '2078-12-31')
   End ) ExpDate,
--
--
--Convert(Datetime,Substring(dbo.Credit_Card.Expiry,1,2)+'/'+'01/'+'20'+Substring(dbo.Credit_Card.Expiry,4,2)), 
--substring(dbo.Credit_Card.Expiry,1,2)+'/'+'01/'+'20'+Substring(dbo.Credit_Card.Expiry,4,2),
	dbo.Contract_Payment_Item.Amount PayAmt, 
	dbo.Location.CounterCode PayLoc

FROM         dbo.Credit_Card INNER JOIN
                      dbo.Credit_Card_Payment ON dbo.Credit_Card.Credit_Card_Key = dbo.Credit_Card_Payment.Credit_Card_Key INNER JOIN
                      dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID RIGHT OUTER JOIN
                      dbo.Contract_Payment_Item INNER JOIN
                      dbo.Business_Transaction ON 
                      dbo.Contract_Payment_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.Location ON dbo.Contract_Payment_Item.Collected_At_Location_ID = dbo.Location.Location_ID ON 
                      dbo.Credit_Card_Payment.Contract_Number = dbo.Contract_Payment_Item.Contract_Number AND 
                      dbo.Credit_Card_Payment.Sequence = dbo.Contract_Payment_Item.Sequence

where  dbo.Contract_Payment_Item.contract_number =Convert(int, @CtrctNumber)
GO
