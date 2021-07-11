USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetReimbursementReasons]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetReimbursementReasons]
AS
Select Distinct
	Reason
From
	Reimbursement_Reason
Where
	Reason = 'Taxi'
UNION ALL
Select Distinct
	Reason
From
	Reimbursement_Reason
Where
	Reason <> 'Taxi'
Return 1












GO
