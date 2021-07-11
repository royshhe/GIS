USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISAdminUserList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*  
               Programmer:   Roy He
               Date:              Feb 05, 2001
               Details:           
*/



CREATE PROCEDURE  [dbo].[SecGetGISAdminUserList]
   
     @UserID varchar(255),
     @Applicaiton varchar(255),
     @Security_Level varchar(255),	
     @Status varchar(20)

as 
    select * from GIS_Security_Admin where Admin_ID=@UserID and Application=@Applicaiton and Security_Level= @Security_Level and status=@status
   







GO
