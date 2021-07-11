USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSystemValueData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSystemValueData    Script Date: 2/18/99 12:11:40 PM ******/
/****** Object:  Stored Procedure dbo.GetSystemValueData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSystemValueData    Script Date: 1/11/99 1:03:17 PM ******/
CREATE PROCEDURE [dbo].[GetSystemValueData]
@ColumnName varchar(30)
AS
Declare @tempStr varchar(255)
Select @tempStr = 'Select ' + @ColumnName + ' From System_Values'
execute (@tempStr)
Return 1








GO
