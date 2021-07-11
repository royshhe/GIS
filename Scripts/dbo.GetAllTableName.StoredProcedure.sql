USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllTableName]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: 	To retrieve tables name.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllTableName]
AS

select
	Distinct
	'name' = substring(CONVERT(VarChar(128), o.name), 1, 40),
	'count' = '0'

from 	sysobjects o,
	master.dbo.spt_values v

where	o.xtype = substring(v.name,1,2)
and 	v.type = 'O9T'
and	o.xtype = 'U'



















GO
