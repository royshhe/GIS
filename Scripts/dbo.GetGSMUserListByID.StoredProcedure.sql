USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGSMUserListByID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*  
               Programmer:   Jack Jian
               Date:              Feb 05, 2001
               Details:           
*/



CREATE PROCEDURE  [dbo].[GetGSMUserListByID]
   
     @UserID varchar(255),
     @Status varchar(255)

as 
            if @status=''
                   begin     
                         if  @UserID='' 
                                select * from  GIS_Security_Admin  order by Admin_ID 
                         else
                                select * from GIS_Security_Admin where Admin_ID=@UserID 
                   end
             else
                   begin     
                         if  @UserID='' 
                                select * from  GIS_Security_Admin where status=@status order by Admin_ID 
                         else
                                select * from GIS_Security_Admin where Admin_ID=@UserID  and status=@status
                   end 




GO
