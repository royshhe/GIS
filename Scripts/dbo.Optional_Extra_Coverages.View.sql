USE [GISData]
GO
/****** Object:  View [dbo].[Optional_Extra_Coverages]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.Optional_Extra_Coverages    Script Date: 2/18/99 12:11:36 PM ******/
/****** Object:  View dbo.Optional_Extra_Coverages    Script Date: 2/16/99 2:05:38 PM ******/
/****** Object:  View dbo.Optional_Extra_Coverages    Script Date: 1/11/99 1:03:13 PM ******/
/*
VIEW NAME: Optional_Extra_Coverages
PURPOSE: To retrieve all optional extras that are coverages
AUTHOR: Don Kirkby
DATE CREATED: Aug 28, 1998
CALLED BY: Contract
REQUIRES: If you change the list of types, also change them in
	Optional_Extra_Other
ENSURES: returns all fields from the optional_extra table
MOD HISTORY:
Name    Date        Comments
*/
CREATE VIEW [dbo].[Optional_Extra_Coverages] AS
SELECT	*

  FROM	optional_extra
 WHERE	type IN ('LDW', 'BUYDOWN', 'PAI', 'PEC', 'CARGO','ELI','PAE','RSN')
GO
