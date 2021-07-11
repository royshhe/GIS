USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCoveragesByRes]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByRes    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByRes    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByRes    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByRes    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the optional extrares covered for the reservation.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCoveragesByRes]
	@ConfirmNum Varchar(11)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iConfirmNum Int
	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

DECLARE @OptExtraId SmallInt
DECLARE @OptExtraType Varchar(20)
DECLARE CoveragesCur CURSOR FAST_FORWARD FOR
	SELECT	RRA.optional_extra_id, OE.Type
	FROM	Optional_Extra OE,
		Reserved_Rental_Accessory RRA
	WHERE	RRA.Optional_Extra_Id = OE.Optional_Extra_ID
	AND	Confirmation_Number = @iConfirmNum
DECLARE @LdwLevel SmallInt
DECLARE @LdwBuydown SmallInt
DECLARE @PAE SmallInt
DECLARE @RSN SmallInt
DECLARE @Cargo SmallInt
DECLARE @ELI SmallInt

	OPEN CoveragesCur
	FETCH NEXT FROM CoveragesCur INTO @OptExtraId, @OptExtraType
	WHILE (@@fetch_status = 0)
	BEGIN
		IF @OptExtraType = 'LDW'
			SELECT @LdwLevel = @OptExtraId
		ELSE IF @OptExtraType = 'Buydown'
			SELECT @LdwBuydown = @OptExtraId
		ELSE IF @OptExtraType = 'PAE'
			SELECT @PAE = @OptExtraId
		ELSE IF @OptExtraType = 'RSN'
			SELECT @RSN = @OptExtraId
		ELSE IF @OptExtraType = 'CARGO'
			SELECT @Cargo = @OptExtraId
	    ELSE IF @OptExtraType = 'ELI'
			SELECT @ELI = @OptExtraId
	
		FETCH NEXT FROM CoveragesCur INTO @OptExtraId, @OptExtraType
	END
	
	CLOSE CoveragesCur
	DEALLOCATE CoveragesCur

	SELECT 	@LdwLevel,
		@LdwBuydown,
		@PAE,
		@RSN,
		@Cargo,
		@ELI
	RETURN 1
GO
