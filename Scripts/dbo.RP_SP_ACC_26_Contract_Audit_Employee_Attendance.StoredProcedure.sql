USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_26_Contract_Audit_Employee_Attendance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_ACC_26_Contract_Audit_Employee_Attendance] -- '2014-01-01', '2014-11-30'
(
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

SELECT
	User_ID,
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
FROM   Employee_Attendance
where Attendance_Date between @paramTransStartDate and @paramTransEndDate
Group by User_ID--,Attendance_Type



 
GO
