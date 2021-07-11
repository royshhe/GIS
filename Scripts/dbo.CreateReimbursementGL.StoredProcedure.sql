USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateReimbursementGL]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetReimbursementReasons    Script Date: 1/11/99 1:03:16 PM ******/
create PROCEDURE [dbo].[CreateReimbursementGL]
@Reason varchar(255),
@GL_reimbursement_account_Code varchar(32)
AS
insert into Reimbursement_Reason (Reason, GL_reimbursement_account_Code)
VALUES (@Reason, NULLIF(@GL_reimbursement_account_Code,''))
GO
