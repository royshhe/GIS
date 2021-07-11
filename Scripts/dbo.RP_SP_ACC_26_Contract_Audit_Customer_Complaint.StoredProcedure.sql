USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_26_Contract_Audit_Customer_Complaint]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RP_SP_ACC_26_Contract_Audit_Customer_Complaint] -- '2014-01-01', '2014-11-30'
(
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SELECT
    lt.value as Complaint_Category,
	User_ID,
	Complaint_Category, 
	Complaint_Date, 
	Contract_Number, 
	Origin, 
	Refund_Amount, 
	Issue, 
	Resolution
--select *
FROM Customer_Complaint left join lookup_table lt on lt.category='Customer Complaint' and lt.code=Complaint_Category
where Complaint_Date between @paramTransStartDate and @paramTransEndDate

GO
