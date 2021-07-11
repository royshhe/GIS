USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Employee_Activity]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create PROCEDURE [dbo].[RP_SP_ACC_29_Employee_Activity]  --'Location CSR', '*', '2015-12-25', '2015-12-31' , '2015-12-25', '2015-12-31'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramConADStartDate varchar(20) = '31 Jul 1999',
	@paramConADEndDate varchar(20) = '31 Jul 1999',
	@paramCCStartDate varchar(20) = '31 Jul 1999',
	@paramCCEndDate varchar(20) = '31 Jul 1999',
	@paramAttdStartDate varchar(20) = '31 Jul 1999',
	@paramAttdEndDate varchar(20) = '31 Jul 1999',
	@paramEDStartDate  varchar(20) = '31 Jul 1999',
	@paramEDEndDate varchar(20) = '31 Jul 1999'
	
)

AS

SET ANSI_NULLS OFF
SET CONCAT_NULL_YIELDS_NULL OFF 


DECLARE @transConADStartDate varchar(20),@transConADEndDate varchar(20)
SELECT	@transConADStartDate	=  convert(varchar(20),CONVERT(datetime,@paramConADStartDate),120),
	@transConADEndDate	= convert(varchar(20), CONVERT(datetime, @paramConADEndDate),120)	

CREATE TABLE #EmployeeActivity(
    User_ID [varchar](25) NOT NULL,
	ActivityType [varchar](25) NOT NULL,
	TransYear INT NULL,
	TransMonth [varchar](25) NULL,
	TransMonthName Varchar(20) null,
	ContractOpened INT NULL,
	AuditType char(02) null, 
	AuditTypeName varchar(50) null, 
	TotalAudits int null,
	TotalAmount int null,
	SumTotalAudits int null,
	MistakeRatio decimal(9,2) null,

	ConAuditType Varchar(50) null,  
	Issue  Varchar(50) null,
	issue_date  datetime null,
	Description  Varchar(80) null,
	ConAuditRA  Varchar(25) null,
	Amount_Affected decimal(9,2) null,
	ConAuditRemarks Varchar(80) null,

    Complaint_Category Varchar(25) null,
	Complaint_Category_Code  Varchar(10) null, 
	Complaint_Date  datetime null, 
	Contract_Number  Varchar(25) null, 
	Origin  Varchar(25) null, 
	Refund_Amount  decimal(9,2) null, 
	Complaint_Issue  Varchar(500) null, 
	Resolution  Varchar(500) null,

	Absent smallint null,
	LateIn smallint null,
	EarlyOut smallint null,
	Sick smallint null,
	HandPunch smallint null,
	Leave smallint null,
	Other smallint null,

	Attendance_Date Datetime Null,
	Attendance_End_Date Datetime Null,
	AttendanceType Varchar(25) null,
	Reason Varchar(250) null,
	Remarks  Varchar(100) null,

	Claim_file_number Varchar(25) null,
	Incident_Date Datetime Null,
	Damage_Amount  decimal(9,2) null,
	unit_number  int null,
	model_name Varchar(25) null,

 	WarningType Varchar(25) null,
	Warning_Date Datetime Null,
	WarningDescription Varchar(250) null

) ON [PRIMARY]


--[dbo].[RP_SP_ACC_29_Contract_Audit] --'Location CSR', '*', '2015-12-25', '2015-12-31'
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
   				And bu.RBR_Date between @transConADStartDate and @transConADEndDate
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
    
    
Insert INTO #EmployeeActivity  
	Select TotalOpens.User_ID, 'ContractAudit' as ActivityType,

		TotalOpens.TransYear, 
		rtrim(ltrim(convert(varchar(5),TotalOpens.TransYear)))+'-'+right('0'+rtrim(ltrim(convert(varchar(5),TotalOpens.TransMonth))),2) as TransMonth, 
		TotalOpens.TransMonthName  as TransMonthName,	
		TotalOpens.ContractOpened,
		TotalOpens.AuditType,
		TotalOpens.AuditTypeName,
		ConAudit.TotalAudits,
		ConAudit.TotalAmount,
		ConAuditSUM.TotalAudits,	
		--ISNULL(ConAuditSUM.TotalAudits,0.00) 
		Convert(decimal(9,2),ISNULL(ConAuditSUM.TotalAudits,0.00))/Convert( decimal(9,2),ISNULL(TotalOpens.ContractOpened,1.00))*100.00 MistakeRatio,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,

	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,  
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null,
		Null


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
			Where dbo.Contract_Audit.Issue_Date   between @transConADStartDate and @transConADEndDate		
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
			Where dbo.Contract_Audit.Issue_Date   between @transConADStartDate and @transConADEndDate		
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
  


--[dbo].[RP_SP_ACC_29_Contract_Audit_Detail]-- '01 jan 2014', '2014-11-30'


Insert INTO #EmployeeActivity  
	SELECT  
		CA.User_ID,  'ContractAuditDetail' as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		lt1.value as Type,  
		lt2.Value as Issue,
		issue_date,
		Description,
		Contract_number,
		Amount_Affected,
		Remarks,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,  
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null,
		Null

	--select *
	FROM  dbo.Contract_Audit CA
	 Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On CA.User_ID=GISUserGroup.User_ID

			left join lookup_table lt1 on lt1.category='Contract Audit Type' and lt1.code=CA.Type
			left join lookup_table lt2 on lt2.category='Contract Audit Issue' and lt2.code=CA.Issue
	where issue_date between @transConADStartDate and @transConADEndDate
	AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
	AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)
	   			
	order by issue_date

--[dbo].[RP_SP_ACC_29_Customer_Complaint] --'Location CSR', '*', '2015-12-25', '2015-12-31'

Insert INTO #EmployeeActivity  
	SELECT
		Customer_Complaint.User_ID,  'CustomerComplaint' as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		lt.value ,
		Complaint_Category, 
		Complaint_Date, 
		Contract_Number, 
		Origin, 
		Refund_Amount, 
		Issue, 
		Resolution,
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,  
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null,
		Null


	--select *
	FROM Customer_Complaint 
	 Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On Customer_Complaint.User_ID=GISUserGroup.User_ID

	left join lookup_table lt on lt.category='Customer Complaint' and lt.code=Complaint_Category
	where Complaint_Date between @paramCCStartDate and @paramCCEndDate
	AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
	AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

--[dbo].[RP_SP_ACC_29_Employee_Attendance] -- '2014-01-01', '2014-11-30'

/*
Category	Code	Value
Employee Attendance      	01                       	Absent
Employee Attendance      	02                       	Late in 
Employee Attendance      	03                       	Early out 
Employee Attendance      	04                       	Sick
Employee Attendance      	05                       	forgot Punch
Employee Attendance      	06                       	No Hand Punch
Employee Attendance      	07                       	Sick Leave
Employee Attendance      	08                       	Marternal Leave
Employee Attendance      	09                       	WCB
Employee Attendance      	10                       	Last Working Day
*/

Insert INTO #EmployeeActivity  
	SELECT
		Employee_Attendance.User_ID,  'EmployeeAttendance' as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null,

		sum(case when Attendance_Type='01'
				then datediff(day,isnull(Attendance_date,getdate()),isnull(Attendance_End_Date+1,getdate()))
				else 0
		end) as Absent,
		sum(case when Attendance_Type='02'
				then 1
				else 0
		end) as LateIn ,
		sum(case when Attendance_Type='03'
				then 1
				else 0
		end) as EarlyOut ,
		sum(case when Attendance_Type='04'
				then datediff(day,isnull(Attendance_date,getdate()),isnull(Attendance_End_Date+1,getdate()))
				else 0
		end) as Sick,
		sum(case when Attendance_Type='05' or  Attendance_Type='06'
				then 1
				else 0
		end) as HandPunch,
		sum(case when Attendance_Type='07' or  Attendance_Type='08' or  Attendance_Type='09'
				then datediff(day,isnull(Attendance_date,getdate()),isnull(Attendance_End_Date+1,getdate()))
				else 0
		end) as Leave,
		sum(case when Attendance_Type='10'
				then 1
				else 0
		end) as Other,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null,
		Null

	--select *
	FROM   Employee_Attendance   Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On Employee_Attendance.User_ID=GISUserGroup.User_ID

	where Attendance_Date between @paramAttdStartDate and @paramAttdEndDate
	AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
	AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)
	   			
	Group by Employee_Attendance.User_ID--,Attendance_Type

--[dbo].[RP_SP_ACC_29_Employee_Attendance_Detail] -- '2014-01-01', '2015-01-01'
Insert INTO #EmployeeActivity  
	SELECT
		EA.User_ID,  'AttendanceDetail' as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 

		Attendance_Date,
		Attendance_End_Date,
		lt.value as Type,
		Reason,
		Remarks,

		Null,
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null,
		Null

	--select *


	FROM   Employee_Attendance EA 
	Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On EA.User_ID=GISUserGroup.User_ID

	left join lookup_table lt on lt.category='Employee Attendance' and lt.code=Attendance_Type
	where Attendance_Date between @paramAttdStartDate and @paramAttdEndDate
	AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
	AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

	order by Attendance_Date

-- [dbo].[RP_SP_ACC_29_Employee_Damage] -- '2014-01-01', '2014-11-30'
--[dbo].[RP_SP_ACC_29_Employee_Miss_Damage] -- '2014-01-01', '2014-11-30'

Insert INTO #EmployeeActivity  
	SELECT
		ED.User_ID,  
		case when  Damage_type='01'
				then 'Damage' 
			 when  Damage_type='02'
				then 'MissDamage' 
		end as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 

		Null,
		Null,
		Null,
		Null,
		Null,

		Claim_file_number as FileNo,
		Incident_Date,
		ed.Damage_Amount,
		ed.unit_number,
		model_name,

		Null,
		Null,
		Null

	--select *
	FROM   Employee_Damage ED 
	Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On ED.User_ID=GISUserGroup.User_ID

			left join Vehicle v on v.unit_number=ED.unit_number
			left join vehicle_model_year vmy on v.vehicle_model_id=vmy.vehicle_model_id	
	where Incident_date between @paramEDStartDate and @paramEDEndDate
			and (Damage_type='01' or  Damage_type='02')
			AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
			AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

--[dbo].[RP_SP_ACC_29_Employee_Warning] -- '2014-01-01', '2014-11-30'

Insert INTO #EmployeeActivity  
	SELECT
		EW.User_ID,  'Warning' as ActivityType,

		null,
		null,	
		null,
		null,
		null,	
		null,
		null,	
		null,
		null,
		null,	
	
		Null,  
		Null,
		Null,
		Null,
		Null,
		Null,
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null,

		Null,
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 
		Null, 

		Null,
		Null,
		Null,
		Null,
		Null,

		Null,
		Null,
		Null,
		Null,
		Null,
		
		lt.value as Type,
		Warning_Date,
		Description

	--select *
	FROM   Employee_Warning EW
	Inner Join dbo.GISUserGroupMain_vw GISUserGroup
	On EW.User_ID=GISUserGroup.User_ID

	 left join lookup_table lt on lt.category='Employee Warning' and lt.code=Warning_Type
	 
	Where	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
			AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

select *
from #EmployeeActivity
order by ActivityType

Drop Table #EmployeeActivity


GO
