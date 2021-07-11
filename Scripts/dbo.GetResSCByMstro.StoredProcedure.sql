USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResSCByMstro]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResSCByMstro    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetResSCByMstro    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResSCByMstro    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResSCByMstro    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: GetResSCByMstro
PURPOSE: To retrieve existing and requested standard comments.
AUTHOR: Don Kirkby
DATE CREATED: Oct 19, 1998
CALLED BY: Reservation
ENSURES: Any existing comments for
	a reservation are returned followed by a list of requested
	comments. The same comment could appear in both lists.
MOD HISTORY:
Name    Date        Comments
Don K	Dec 14 1998 Removed ConfirmNum parameter and stopped returning
		existing comments, exists, and reversed sort order
		Added quantity parameters
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetResSCByMstro]
	@Code1			varchar(3),
	@Qty1			varchar(6),
	@Code2			varchar(3),
	@Qty2			varchar(6),
	@Code3			varchar(3),
	@Qty3			varchar(6),
	@Code4			varchar(3),
	@Qty4			varchar(6),
	@Code5			varchar(3),
	@Qty5			varchar(6),
	@Code6			varchar(3),
	@Qty6			varchar(6),
	@Code7			varchar(3),
	@Qty7			varchar(6)
AS
	DECLARE	@nQty1 SmallInt,
			@nQty2 SmallInt,
			@nQty3 SmallInt,
			@nQty4 SmallInt,
			@nQty5 SmallInt,
			@nQty6 SmallInt,
			@nQty7 SmallInt
	
	SELECT	@nQty1 = CONVERT(smallint, NULLIF(@Qty1,'')),
			@nQty2 = CONVERT(smallint, NULLIF(@Qty2,'')),
			@nQty3 = CONVERT(smallint, NULLIF(@Qty3,'')),
			@nQty4 = CONVERT(smallint, NULLIF(@Qty4,'')),
			@nQty5 = CONVERT(smallint, NULLIF(@Qty5,'')),
			@nQty6 = CONVERT(smallint, NULLIF(@Qty6,'')),
			@nQty7 = CONVERT(smallint, NULLIF(@Qty7,''))

	SELECT	reservation_comment_id,
		maestro_spec_equip_code
	  FROM	reservation_standard_comment
	 WHERE	(	(   maestro_spec_equip_code = @Code1
			AND maestro_spec_equip_quantity
				= @nQty1
			)
		    OR	(   maestro_spec_equip_code = @Code2
			AND maestro_spec_equip_quantity
				= @nQty2
			)
		    OR	(   maestro_spec_equip_code = @Code3
			AND maestro_spec_equip_quantity
				= @nQty3
			)
		    OR	(   maestro_spec_equip_code = @Code4
			AND maestro_spec_equip_quantity
				= @nQty4
			)
		    OR	(   maestro_spec_equip_code = @Code5
			AND maestro_spec_equip_quantity
				= @nQty5
			)
		    OR	(   maestro_spec_equip_code = @Code6
			AND maestro_spec_equip_quantity
				= @nQty6
			)
		    OR	(   maestro_spec_equip_code = @Code7
			AND maestro_spec_equip_quantity
				= @nQty7
			)
		)
	   AND	maestro_spec_equip_code != ''
	 ORDER
	    BY	maestro_spec_equip_code desc
	RETURN @@ROWCOUNT













GO
