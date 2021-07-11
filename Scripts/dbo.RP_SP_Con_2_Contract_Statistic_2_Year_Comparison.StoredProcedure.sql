USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
                                They are Contract_CI_Curr and Contract_CO_Curr. Contract_CI_Curr will summarize all closed contract statistics. 
                                Contract_CO_Curr will list all check out contracts. 
*/
/* updated to ver 80 */
CREATE PROCEDURE [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison] --'2012-01-01','2012-03-31','Car','*'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
	@paramVehTypeID varchar(20) = '*',
	@paramLocID varchar(100) = '43'
)
AS

SET NOCOUNT ON

-- fix upgrading problem (SQL7->SQL2000)

Exec [svbvm080].[gisdata].[dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison] @paramStartDate,@paramEndDate,@paramVehTypeID,@paramLocID

-- if @paramLocID='Total'
--	begin
--		exec [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_for All Location Total] @paramStartDate,@paramEndDate,@paramVehTypeID,'*'
--	end
--else
--  begin
--	exec [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_1] @paramStartDate,@paramEndDate,@paramVehTypeID,@paramLocID
--  end

 
GO
