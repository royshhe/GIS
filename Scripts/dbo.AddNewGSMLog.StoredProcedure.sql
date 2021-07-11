USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AddNewGSMLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*  
               Programmer:   Jack Jian
               Date:              Feb 05, 2001
               Details:           
*/



CREATE PROCEDURE [dbo].[AddNewGSMLog] 
   @UserID varchar(255),
   @Logtime varchar(255),
   @Logtype varchar(255),
   @LogDetails varchar(255)

as
    
      insert into GIS_Security_Audit_Log values(@Userid,@logtime,@logtype, @LogDetails)




GO
