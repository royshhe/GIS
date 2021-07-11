USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOptExtrasByTypes]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResOptExtrasByTypes    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtrasByTypes    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtrasByTypes    Script Date: 1/11/99 1:03:16 PM ******/
/*
PROCEDURE NAME: GetResOptExtrasByTypes
PURPOSE: To retrieve coverages requested by type
AUTHOR: Don Kirkby
DATE CREATED: Oct 21, 1998
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
Don K	Dec 8 1998  Stopped returning existing optional extras because
			they get deleted before this is called.
			Also reversed sorting direction
Don K	Dec 14 1998 Removed @ConfirmNum parameter and exists field
*/
CREATE PROCEDURE [dbo].[GetResOptExtrasByTypes] --'r','','ldw',''
	@VehClassCode		varchar(1),
	@Type1			varchar(20),
	@Type2			varchar(20),
	@Type3			varchar(20)
AS
	SELECT @VehClassCode = NULLIF(@VehClassCode, '')
/* First part is a list of requested optional extras
 * (excluding LDW)
 */
	SELECT	optional_extra_id,
		type
	  FROM	optional_extra
	 WHERE	type IN (@Type1, @Type2, @Type3)
	   AND	type NOT IN ('', 'LDW')
	   AND	delete_flag = 0
UNION ALL
/* Second part is LDW if requested
 */
	SELECT	distinct vc.default_optional_extra_id,
		oe.type
	FROM         dbo.Optional_Extra OE INNER JOIN
                 dbo.Optional_Extra_Price OEP ON OE.Optional_Extra_ID = OEP.Optional_Extra_ID INNER JOIN
                      dbo.Vehicle_Class VC ON OE.Optional_Extra_ID = VC.Default_Optional_Extra_ID
	 WHERE	VC.vehicle_class_code = @VehClassCode
	   AND	oe.type IN (@Type1, @Type2, @Type3)
	   AND	oe.type = 'LDW'
	   AND	oe.delete_flag = 0
	   and (oep.valid_to is null or oep.valid_to>=getdate())

	 ORDER
	    BY	2 desc

	RETURN @@ROWCOUNT

--/* Second part is LDW if requested
-- */
--	SELECT	distinct vc.default_optional_extra_id,
--		oe.type
--	  FROM	optional_extra oe,
--			Optional_Extra_Price OEP,
--		ldw_deductible ld,
--		vehicle_class VC
--	 WHERE	ld.optional_extra_id = oe.optional_extra_id
--	   AND	ld.vehicle_class_code = @VehClassCode
--	   AND	oe.type IN (@Type1, @Type2, @Type3)
--	   AND	oe.type = 'LDW'
--	   AND	oe.delete_flag = 0
--	   And ld.vehicle_class_code=vc.vehicle_class_code
----	   and	ld.ldw_deductible =
----		(SELECT	MIN(ld2.ldw_deductible)
----		   FROM	optional_extra oe2,
----			ldw_deductible ld2
----		  WHERE	ld2.optional_extra_id = oe2.optional_extra_id
----		    AND	ld2.vehicle_class_code = @VehClassCode
----		    AND	oe2.type = 'LDW'
----		    AND	oe2.delete_flag = 0
----		)
--		and oep.optional_extra_id = oe.optional_extra_id and (oep.valid_to is null or oep.valid_to>=getdate())
--	 ORDER
--	    BY	2 desc
--	RETURN @@ROWCOUNT
GO
