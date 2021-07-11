USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetDefaultUserPassword]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             May 10, 2001
-------        Details:           Get contract print/copy sequence number
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetDefaultUserPassword]

	@user_name varchar(255) ,
	@password varchar(255) output
as

	select 
		@password = Admin_Password 
	from 		gis_security_admin
	where
		Admin_ID = @user_name
		and Status = 'A'


GO
