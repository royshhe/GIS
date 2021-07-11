USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Customer_Complaint]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Customer_Complaint] --'Location CSR', '*', '2015-12-25', '2015-12-31'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SELECT
    lt.value as Complaint_Category,
	Customer_Complaint.User_ID,
	Complaint_Category, 
	Complaint_Date, 
	Contract_Number, 
	Origin, 
	Refund_Amount, 
	Issue, 
	Resolution
--select *
FROM Customer_Complaint 
 Inner Join dbo.GISUserGroupMain_vw GISUserGroup
On Customer_Complaint.User_ID=GISUserGroup.User_ID

left join lookup_table lt on lt.category='Customer Complaint' and lt.code=Complaint_Category
where Complaint_Date between @paramTransStartDate and @paramTransEndDate
AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)
   			

GO
