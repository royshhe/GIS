USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetScreenDetails]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Sharon Li
----  Date: 	 Jul 12, 2005
----  Details:	 retrieve screen details
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecGetScreenDetails] 
	@is_new int = 0 ,
	@screen_num varchar(50) ='' 
as

SET XACT_ABORT on
SET NOCOUNT ON

	if @is_new = 1
	begin
		SELECT (MAX(screen_number)+1) AS Screen_Number FROM GISScreenIDs  
	end
	else
	begin
		SELECT * FROM GISScreenIDs WHERE screen_number = @screen_num
	end

SET XACT_ABORT off
SET NOCOUNT Off





GO
