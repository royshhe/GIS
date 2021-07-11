USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDependancyCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








CREATE PROCEDURE [dbo].[GetDependancyCount]
	@TableName VarChar(40)

AS
select	Count(*)

from 	sysobjects o,
	master.dbo.spt_values v,
	sysdepends d,
	sysusers s

where	o.id = d.id
and 	o.xtype = substring(v.name,1,2) and v.type = 'O9T'
and 	d.depid = Object_id(NULLIF(@TableName, ''))
and 	o.uid = s.uid














GO
