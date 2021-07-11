USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PerfTest]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.PerfTest    Script Date: 2/18/99 12:11:40 PM ******/
/****** Object:  Stored Procedure dbo.PerfTest    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.PerfTest    Script Date: 12/22/98 10:13:23 AM ******/
CREATE PROCEDURE [dbo].[PerfTest]
AS
Declare @i int
Declare @str varchar(255)
Select @i = 0
While (@i < 101)
	Begin
		Select @str = '#tbl' + Convert(char(4),@i) +
		'(field1 varchar(255),field2 int)'
		Execute ("Create Table " + @str)
		Select 'Temporary table #' + Convert(char(4),@i) + ' Created'
		Select @i = @i + 1
	End
Return 1












GO
