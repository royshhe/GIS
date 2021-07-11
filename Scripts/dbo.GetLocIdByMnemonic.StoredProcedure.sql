USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocIdByMnemonic]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.GetLocIdByMnemonic    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByMnemonic    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByMnemonic    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByMnemonic    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetLocIdByMnemonic
PURPOSE: To retrieve a location
AUTHOR: Don Kirkby
DATE CREATED: Sep 30, 1998
CALLED BY: MaestroBatch
REQUIRES: corporate mnemonic code
ENSURES: the record is returned.
MOD HISTORY:
Name    Date        Comments
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetLocIdByMnemonic] -- 'v05'
	@Mnemonic varchar(4)
AS
	SELECT	@Mnemonic = NULLIF(@Mnemonic, '')
	SELECT 	Location_Id,
			(case when l.owning_company_id in (select Code from Lookup_Table where Category = 'BudgetBC Company')
					then 1
					else 0
			end) as Own
--select *			
	FROM	Location l 

	WHERE	mnemonic_code = @Mnemonic
			or 
			TK_mnemonic_code  = @Mnemonic
--			and mnemonic_code not in (select PhelpsLoc.mnemonic_code
--from  svbvm032.gisdata.dbo.location PhelpsLoc
--where  PhelpsLoc.rental_location=1 and PhelpsLoc.owning_company_id=7409
-- and not ( PhelpsLoc.location like ('%North Van%') or 
--	PhelpsLoc.location like ('%Kingsway%') or 
--PhelpsLoc.location like ('%richmond%') ))
	RETURN @@ROWCOUNT
GO
