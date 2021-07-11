USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_26_Employee_Attendance_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RP_SP_ACC_26_Employee_Attendance_Detail] -- '2014-01-01', '2015-01-01'
(
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SELECT
	User_ID,
	Attendance_Date,
	Attendance_End_Date,
	lt.value as Type,
	Reason,
	Remarks
--select *
FROM   Employee_Attendance EA left join lookup_table lt on lt.category='Employee Attendance' and lt.code=Attendance_Type
where Attendance_Date between @paramTransStartDate and @paramTransEndDate
order by Attendance_Date


GO
