USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResWithForeignConfNum]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateResWithForeignConfNum]
        @ConfirnationNum int,
	@ForeignConfNum	VarChar(20)
	
AS
	
	UPDATE	Reservation 
		
	SET	Foreign_Confirm_Number = @ForeignConfNum
		
	WHERE	Confirmation_number= @ConfirnationNum  and Foreign_Confirm_Number is null

RETURN @ConfirnationNum
GO
