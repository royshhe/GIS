USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Employee_Warning]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Employee_Warning] -- '2014-01-01', '2014-11-30'
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
AS

SELECT
	EW.User_ID,
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
		and  Warning_Date between @paramTransStartDate and @paramTransEndDate

--where Warning_Date between @paramTransStartDate and @paramTransEndDate




GO
