USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLResCountByResInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOLResCountByResInfo] -- 'i131527656', 'He' 
	@ForeignConfirmNum Varchar(20),
        @LastName varchar(50)


AS

        select count(*), Confirmation_number From Reservation 
	where Foreign_Confirm_number = @ForeignConfirmNum
	AND	Last_Name LIKE LTRIM(@LastName + '%') and source_code<>'Maestro'
	
group by Confirmation_number

RETURN @@ROWCOUNT

 
GO
