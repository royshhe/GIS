USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateMstroLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateMstroLog    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CreateMstroLog    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateMstroLog    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateMstroLog    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateMstroLog
PURPOSE: To create a record in the Maestro table
AUTHOR: Don Kirkby
DATE CREATED: Sep 22, 1998
CALLED BY: MaestroBatch
REQUIRES:
ENSURES: a record is created to log a Maestro Reservation
MOD HISTORY:
Name    Date        Comments
Don K	Nov 24 1998 Changed confirmation_number to foreign_confirm_number
*/
CREATE PROCEDURE [dbo].[CreateMstroLog]
	@UpdateFlag varchar(1),
	@TxDate varchar(24),
	@SeqNum varchar(6),
	@ConfNum varchar(11),
	@Data1 varchar(255),
	@Data2 varchar(255),
	@Data3 varchar(255),
	@Data4 varchar(255),
	@Data5 varchar(255),
	@FConfNum varchar(20)
AS
	INSERT
	  INTO	maestro
		(
		gis_process_date,
		update_gis_indicator,
		transaction_date,
		sequence_number,
		confirmation_number,
		foreign_confirm_number,
		maestro_data
		)
	VALUES	(
		GETDATE(),
		CONVERT(bit, NULLIF(@UpdateFlag, '')),
		CONVERT(datetime, NULLIF(@TxDate, '')),
		CONVERT(int, NULLIF(@SeqNum, '')),
		CONVERT(int, NULLIF(@ConfNum, '')),
		NULLIF(@FConfNum, ''),
		NULLIF(@Data1 + @Data2 + @Data3 + @Data4 + @Data5, '')
		)
	RETURN @@IDENTITY












GO
