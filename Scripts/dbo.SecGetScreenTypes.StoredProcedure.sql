USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetScreenTypes]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Sharon Li
----  Date: 	 Jul 12, 2005
----  Details:	 retrieve screen Types
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecGetScreenTypes] 
as

SET XACT_ABORT on
SET NOCOUNT ON

	select code, value from  Lookup_table where Category = 'GISScreenType' 

SET XACT_ABORT off
SET NOCOUNT Off





GO
