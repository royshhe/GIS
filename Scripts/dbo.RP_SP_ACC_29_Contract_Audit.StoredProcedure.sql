USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Contract_Audit]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Contract_Audit]   --'*', '*', '2015-12-01', '2015-12-31'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SET ANSI_NULLS OFF
SET CONCAT_NULL_YIELDS_NULL OFF 


DECLARE @transStartDate varchar(20),@transEndDate varchar(20)
SELECT	@transStartDate	=  convert(varchar(20),CONVERT(datetime,@paramTransStartDate),120),
	@transEndDate	= convert(varchar(20), CONVERT(datetime, @paramTransEndDate),120)	


CREATE TABLE #TotalOpens(
    User_ID [varchar](25) NOT NULL,
	ContractOpened INT NULL,
	TransYear INT NULL,
	TransMonth INT NULL,
	TransMonthName Varchar(20) 
	
) ON [PRIMARY]

Insert into #TotalOpens

	Select  ConBus.User_ID, 
	count(*) as ContractOpened, 
	ConBus.TransYear, 
	ConBus.TransMonth, 
	DATENAME(month,ConBus.RBR_Date_Adj)TransMonthName from 
		(SELECT bu.RBR_Date, 	
			 --  (Case 
				--	When Month(bu.RBR_Date) in (1,3,5,7,8,10,12)  then  Dateadd(d, 6,bu.RBR_Date)
				--	When Month(bu.RBR_Date) in (4,6,9,11)  Then Dateadd(d, 5,bu.RBR_Date)
				--	When Month(bu.RBR_Date) =2   Then 
				--		(Case When dbo.IsLeapYear(bu.RBR_Date)=1 Then Dateadd(d, 4,bu.RBR_Date)
				--			Else Dateadd(d, 3,bu.RBR_Date)
				--			End
				--		)
				--End) 
				
				 dbo.CutOffDate (bu.RBR_Date) RBR_Date_Adj,
					
				--Year(Case 
				--	When Month(bu.RBR_Date) in (1,3,5,7,8,10,12)  then  Dateadd(d, 6,bu.RBR_Date)
				--	When Month(bu.RBR_Date) in (4,6,9,11)  Then Dateadd(d, 5,bu.RBR_Date)
				--	When Month(bu.RBR_Date) =2   Then 
				--		(Case When dbo.IsLeapYear(bu.RBR_Date)=1 Then Dateadd(d, 4,bu.RBR_Date)
				--			Else Dateadd(d, 3,bu.RBR_Date)
				--			End
				--		)
				--End) 
				Year(dbo.CutOffDate (bu.RBR_Date))	TransYear, 
				
				--Month(Case 
				--	When Month(bu.RBR_Date) in (1,3,5,7,8,10,12)  then  Dateadd(d, 6,bu.RBR_Date)
				--	When Month(bu.RBR_Date) in (4,6,9,11)  Then Dateadd(d, 5,bu.RBR_Date)
				--	When Month(bu.RBR_Date) =2   Then 
				--		(Case When dbo.IsLeapYear(bu.RBR_Date)=1 Then Dateadd(d, 4,bu.RBR_Date)
				--			Else Dateadd(d, 3,bu.RBR_Date)
				--			End
				--		)
				--End) 
				Month(dbo.CutOffDate (bu.RBR_Date))	TransMonth, 
				
				bu.Contract_Number, 
				CON.Confirmation_Number, 
				bu.Transaction_Description, 
				WOC.Location_ID AS Contract_Opened_At_Location_ID, 
                Loc.Location AS Contract_Opened_At_Location_Name, 
						WOC.User_ID
		FROM  dbo.Business_Transaction AS bu WITH (NOLOCK) 
			INNER JOIN --dbo.RP__CSR_Who_Opened_The_Contract AS WOC 
				(SELECT dbo.RP__CSR_Who_Opened_The_Contract.User_id , 
						dbo.GISUsers.user_name, 
						GISUserGroup.group_name,
						dbo.RP__CSR_Who_Opened_The_Contract.Contract_Number,
						Location_ID
						
				 FROM  dbo.GISUsers 
				 INNER JOIN dbo.GISUserGroupMain_vw GISUserGroup
					ON dbo.GISUsers.user_id =  GISUserGroup.user_id 
					INNER JOIN  dbo.RP__CSR_Who_Opened_The_Contract 
						ON dbo.GISUsers.user_name = dbo.RP__CSR_Who_Opened_The_Contract.User_ID
				) AS WOC               
				ON bu.Contract_Number = WOC.Contract_Number 
			INNER JOIN dbo.Location AS Loc 
				ON WOC.Location_ID = Loc.Location_ID 
			INNER JOIN dbo.Contract AS CON 
				ON bu.Contract_Number = CON.Contract_Number
		WHERE (bu.Transaction_Type = 'Con') AND (bu.Transaction_Description = 'Check Out')
   			And bu.RBR_Date between @transStartDate and @transEndDate
   			AND	(@GISUserGroup = '*' OR ltrim(rtrim(WOC.group_name)) = ltrim(rtrim(@GISUserGroup)))
   			AND	(@GISUserName = '*' OR WOC.user_name = @GISUserName)
		) 
	ConBus
	Inner join dbo.Contract_Audit_Period ConPeriod
		On ConBus.RBR_Date between ConPeriod.Period_Start_Date and  ConPeriod.Period_End_Date
		And ConBus.Contract_Opened_At_Location_ID =ConPeriod.Location_ID
	--where ConBus.User_ID='Howie Liao'
	Group by ConBus.User_ID, 	 
	ConBus.TransYear, 	
	DATENAME(month,ConBus.RBR_Date_Adj),	
	ConBus.TransMonth
	order by ConBus.User_ID, 
	ConBus.TransYear, 
	ConBus.TransMonth 
 
 

CREATE TABLE #TotalOpensWithAuditType(
    User_ID [varchar](25) NOT NULL,
	ContractOpened INT NULL,
	TransYear INT NULL,
	TransMonth INT NULL,
	TransMonthName Varchar(20),
	AuditType char(02), 
	AuditTypeName varchar(50) 
	
) ON [PRIMARY]	

Insert INTO #TotalOpensWithAuditType

Select ConOpens.User_ID,
   ConOpens.ContractOpened,
	ConOpens.TransYear, 
	ConOpens.TransMonth, 
	ConOpens.TransMonthName,	
	AuditType.Code Type,
	AuditType.Value TypeName		
	from #TotalOpens ConOpens
	CROSS Join 
    (Select * from Lookup_table where Category='Contract Audit Type') AuditType  
    
    
  
Select TotalOpens.User_ID,
	TotalOpens.TransYear, 
	rtrim(ltrim(convert(varchar(5),TotalOpens.TransYear)))+'-'+right('0'+rtrim(ltrim(convert(varchar(5),TotalOpens.TransMonth))),2) as TransMonth, 
	TotalOpens.TransMonthName  as TransMonthName,	
	TotalOpens.ContractOpened,
	TotalOpens.AuditType,
	TotalOpens.AuditTypeName,
	ConAudit.TotalAudits,
	ConAudit.TotalAmount,
	ConAuditSUM.TotalAudits GrandTotalAudits,	
	--ISNULL(ConAuditSUM.TotalAudits,0.00) 
	Convert(decimal(9,2),ISNULL(ConAuditSUM.TotalAudits,0.00))/Convert( decimal(9,2),ISNULL(TotalOpens.ContractOpened,1.00))*100.00 MistakeRatio
	from #TotalOpensWithAuditType TotalOpens
	--Inner Join (Select * from Lookup_table where Category='Contract Audit Type') AuditType
	--On dbo.Contract_Audit_Issue_Type.Type_ID= AuditType.Code
	
	 
Left Join (
	SELECT  
	GISUsers.User_Name, 
	dbo.Contract_Audit_Issue_Type.Type_ID Type,  
	count(*) TotalAudits, 
	sum(dbo.Contract_Audit.Amount_affected) TotalAmount,
	Year(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)) TransYear,
	Month(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)) TransMonth
		
	FROM  dbo.Contract_Audit 
		INNER JOIN dbo.Contract_Audit_Issue_Type 
		ON dbo.Contract_Audit.Issue = dbo.Contract_Audit_Issue_Type.Issues_ID
		
		
		Inner Join GISUsers On dbo.Contract_Audit.User_ID=GISUsers.User_ID
		Where dbo.Contract_Audit.Issue_Date   between @transStartDate and @transEndDate		
		and dbo.Contract_Audit_Issue_Type.Type_ID<>'12'
		Group by GISUsers.User_Name, 
		dbo.Contract_Audit_Issue_Type.Type_ID,
		Year(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)),
		Month(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date))  
	
               
) ConAudit On TotalOpens.User_ID= ConAudit.User_Name  
	And    TotalOpens.TransYear= ConAudit.TransYear 
	And    TotalOpens.TransMonth= ConAudit.TransMonth 
	And	   TotalOpens.AuditType= ConAudit.Type 


Left Join (
	SELECT  
	GISUsers.User_Name, 
	--dbo.Contract_Audit_Issue_Type.Type_ID Type,  
	count(*) TotalAudits, 
 
	Year(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)) TransYear,
	Month(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)) TransMonth
		
	FROM  dbo.Contract_Audit 
		INNER JOIN dbo.Contract_Audit_Issue_Type 
		ON dbo.Contract_Audit.Issue = dbo.Contract_Audit_Issue_Type.Issues_ID
		
		
		Inner Join GISUsers On dbo.Contract_Audit.User_ID=GISUsers.User_ID
		Where dbo.Contract_Audit.Issue_Date   between @transStartDate and @transEndDate		
		and dbo.Contract_Audit_Issue_Type.Type_ID<>'12' 
		Group by GISUsers.User_Name, 
		--dbo.Contract_Audit_Issue_Type.Type_ID,
		Year(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date)),
		Month(dbo.CutOffDate (dbo.Contract_Audit.Issue_Date))  
	
               
) ConAuditSUM On TotalOpens.User_ID= ConAuditSUM.User_Name  
	And    TotalOpens.TransYear= ConAuditSUM.TransYear 
	And    TotalOpens.TransMonth= ConAuditSUM.TransMonth 
	--And	   TotalOpens.AuditType= ConAuditSUM.Type 
	

Order by TotalOpens.User_ID,TotalOpens.TransYear, TotalOpens.TransMonth,TotalOpens.AuditType


--select DATENAME(month,'2014-01-01')    


Drop Table #TotalOpens
Drop Table #TotalOpensWithAuditType
  

GO
