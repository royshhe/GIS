USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_26_Contract_Audit_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_ACC_26_Contract_Audit_Detail]-- '01 jan 2014', '2014-11-30'
(
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS
SET ANSI_NULLS OFF
SET CONCAT_NULL_YIELDS_NULL OFF 


DECLARE @transStartDate varchar(20),@transEndDate varchar(20)
SELECT	@transStartDate	=  convert(varchar(20),CONVERT(datetime,@paramTransStartDate),120),
	@transEndDate	= convert(varchar(20), CONVERT(datetime, @paramTransEndDate),120)	


SELECT  
	User_ID, 
	lt1.value as Type,  
	lt2.Value as Issue,
	issue_date,
	Description,
	Contract_number,
	Amount_Affected,
	Remarks
--select *
FROM  dbo.Contract_Audit CA
		left join lookup_table lt1 on lt1.category='Contract Audit Type' and lt1.code=CA.Type
		left join lookup_table lt2 on lt2.category='Contract Audit Issue' and lt2.code=CA.Issue
where issue_date between @transStartDate and @transEndDate
order by issue_date

GO
