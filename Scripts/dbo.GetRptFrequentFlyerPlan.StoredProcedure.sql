USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptFrequentFlyerPlan]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PROCEDURE NAME: GetRptFrequentFlyerPlan
PURPOSE: To retrieve a list of Frequent Flyer Plan and id
AUTHOR: Niem Phan
DATE CREATED: Aug 25, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRptFrequentFlyerPlan]

AS

	Select	Frequent_Flyer_Plan,
		Frequent_Flyer_Plan_ID

	From	Frequent_Flyer_Plan WITH(NOLOCK)

	Order By
		Frequent_Flyer_Plan









GO
