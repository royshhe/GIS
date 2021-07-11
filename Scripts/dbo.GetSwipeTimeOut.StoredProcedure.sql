USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSwipeTimeOut]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetSwipeTimeOut]
@Category varchar(25)
AS
Set Rowcount 1
Select Distinct
	Code
From
	Lookup_Table
Where
	Category = @Category
Return 1


GO
