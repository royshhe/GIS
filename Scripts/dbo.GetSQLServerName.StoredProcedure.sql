USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSQLServerName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*   	Programmer:          Jack Jian
	Date:		   Feb 21, 2001
*/	


CREATE PROCEDURE [dbo].[GetSQLServerName]
    @SQLServer  varchar(255)  output

as
 
	select @SQLServer = @@servername

GO
