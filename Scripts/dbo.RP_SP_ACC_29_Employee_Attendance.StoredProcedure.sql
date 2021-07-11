USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Employee_Attendance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Employee_Attendance] --'*','*',  '2016-01-01', '2016-11-25'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

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

/*
SELECT
	Employee_Attendance.User_ID,
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
	end) as Other

--select *
FROM   Employee_Attendance   Inner Join dbo.GISUserGroupMain_vw GISUserGroup
On Employee_Attendance.User_ID=GISUserGroup.User_ID

where Attendance_Date between @paramTransStartDate and @paramTransEndDate
AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)
   			
Group by Employee_Attendance.User_ID--,Attendance_Type

*/

 
select	UG.User_ID,
		case when Attd.Absent is not null
				then Attd.Absent
				else 0
			end as Absent,
		case when Attd.LateIn is not null
				then Attd.LateIn
				else 0
			end as LateIn,		
		case when Attd.EarlyOut is not null
				then Attd.EarlyOut
				else 0
			end as EarlyOut,		
		case when Attd.Sick is not null
				then Attd.Sick
				else 0
			end as Sick,		
		case when Attd.HandPunch is not null
				then Attd.HandPunch
				else 0
			end as HandPunch,		
		case when Attd.Leave is not null
				then Attd.Leave
				else 0
			end as Leave,		
		case when Attd.Other is not null
				then Attd.Other
				else 0
			end as Other		
from  dbo.GISUserGroupMain_vw UG 
	left join (
		SELECT
			Employee_Attendance.User_ID,
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
			end) as Other

		--select *
		FROM   Employee_Attendance   Inner Join dbo.GISUserGroupMain_vw GISUserGroup
		On Employee_Attendance.User_ID=GISUserGroup.User_ID

		where Attendance_Date between @paramTransStartDate and @paramTransEndDate
		AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
		AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)
		   			
		Group by Employee_Attendance.User_ID--,Attendance_Type
	) Attd 
		on Attd.User_ID=UG.user_id
where (ltrim(rtrim(UG.group_name)) = ltrim(rtrim(@GISUserGroup))) or @GISUserGroup = '*' 
GO
