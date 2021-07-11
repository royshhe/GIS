USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Employee_Attendance_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Employee_Attendance_Detail]-- 'Location CSR' ,'*','2016-01-01', '2016-08-24'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SELECT
	EA.User_ID,
	Attendance_Date,
	Attendance_End_Date,
	lt.value as Type,
	Reason,
	Remarks,
	user_name
--select *


FROM   Employee_Attendance EA 
Inner Join dbo.GISUserGroupMain_vw GISUserGroup
On EA.User_ID=GISUserGroup.User_ID

left join lookup_table lt on lt.category='Employee Attendance' and lt.code=Attendance_Type
where Attendance_Date between @paramTransStartDate and @paramTransEndDate
AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

order by Attendance_Date



GO
