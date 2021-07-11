USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[BackupBCDMatrix]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[BackupBCDMatrix]

as

delete BCDMatrixBak
Insert  into  BCDMatrixBak select *  from BCDMatrix 
delete BCDMatrix
GO
