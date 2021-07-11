USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_26_Employee_Warning]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_ACC_26_Employee_Warning] -- '2014-01-01', '2014-11-30'
AS

SELECT
	User_ID,
	lt.value as Type,
	Warning_Date,
	Description

--select *
FROM   Employee_Warning EW left join lookup_table lt on lt.category='Employee Warning' and lt.code=Warning_Type
--where Warning_Date between @paramTransStartDate and @paramTransEndDate


GO
