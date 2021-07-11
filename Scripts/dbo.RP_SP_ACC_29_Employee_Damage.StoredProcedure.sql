USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_29_Employee_Damage]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_ACC_29_Employee_Damage] -- '2014-01-01', '2014-11-30'
(
	@GISUserGroup varchar(50)='*',
	@GISUserName varchar(50)='*',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999'
)

AS

SELECT
	ED.User_ID,
	Claim_file_number as FileNo,
	Incident_Date,
	ed.Damage_Amount,
	ed.unit_number,
	model_name

--select *
FROM   Employee_Damage ED 
Inner Join dbo.GISUserGroupMain_vw GISUserGroup
On ED.User_ID=GISUserGroup.User_ID

		left join Vehicle v on v.unit_number=ED.unit_number
		left join vehicle_model_year vmy on v.vehicle_model_id=vmy.vehicle_model_id	
where Incident_date between @paramTransStartDate and @paramTransEndDate
		and Damage_type='01'
		AND	(@GISUserGroup = '*' OR ltrim(rtrim(GISUserGroup.group_name)) = ltrim(rtrim(@GISUserGroup)))
		AND	(@GISUserName = '*' OR GISUserGroup.user_name = @GISUserName)

--Group by User_ID,Damage_Type



GO
