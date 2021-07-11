USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLookupTableData]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[CreateLookupTableData]
@Category varchar(30),
@Code char(25),
@Value varchar(255),
@Alias varchar(255) = '',
@Editable bit='0'
AS
if @Category='Reservation Standard Comment'
	Begin
		Insert into	Reservation_Standard_Comment ( Reservation_Comment)
		Values (@Value)
	End
else
	Begin
		Insert 	Lookup_Table
		Values (@Category,@Code,@Value,@Alias,@Editable)
	End
GO
