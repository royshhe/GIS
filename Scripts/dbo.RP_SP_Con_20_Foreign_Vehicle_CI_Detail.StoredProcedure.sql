USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_20_Foreign_Vehicle_CI_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
PROCEDURE NAME: RP_SP_Con_2_Contract_Statistic_New
PURPOSE: Collect Contract Statistics for all budget BC vehicle contract 
AUTHOR:	Linda Qu
DATE CREATED: 2000/06/08
USED BY:  Contract Statistic Report
MOD HISTORY:
Name 		Date		Comments
Linda Qu	June 08 2000	Rewrite Contract Statistic Report in order to solve the SQL Server Access Violation Error
                                Called Microsoft but can't find the source for AV error. Thus we decide to rewrite this report
                                using report table. Two report tables have been introduced for this purpose. 
                                They are Contract_CI and Contract_CO. Contract_CI will summarize all closed contract statistics. 
                                Contract_CO will list all check out contracts. 
*/
/* updated to ver 80 */
CREATE PROCEDURE [dbo].[RP_SP_Con_20_Foreign_Vehicle_CI_Detail] -- '01 jun 2011','30 jun 2011'
(
	@paramStartDate varchar(24) = '01 May 2000 00:00',
	@paramEndDate varchar(24) = '07 May 2000 00:00'
)
AS

SET NOCOUNT ON
DECLARE 	@startDate datetime,
		@endDate datetime

--Check reportoken to avoid that multiple users run this report at the same time
--DECLARE @concurrentRpt char(1)
--select @concurrentRpt=Code FROM Lookup_Table WHERE Category='ReportToken'
--IF @concurrentRpt='1'
--   RETURN
--ELSE UPDATE Lookup_Table Set Code='1' WHERE Category='ReportToken'
--end reporttoken checking

-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime,  @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

select *
from Foreign_Vehicle_CI_Log
where Time_In between @startDate and @endDate
GO
