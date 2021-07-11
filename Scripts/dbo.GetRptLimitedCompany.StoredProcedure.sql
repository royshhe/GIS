USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptLimitedCompany]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/****** Object:  Stored Procedure dbo.GetRptLimitedCompany    Script Date: 2/18/99 12:11:56 PM ******/  
/****** Object:  Stored Procedure dbo.GetRptLimitedCompany    Script Date: 2/16/99 2:05:42 PM ******/  
/*  
PROCEDURE NAME: GetRptLimitedCompany  
PURPOSE: To retrieve a list of owning companies that users at a given  
 location are allowed to see.  
AUTHOR: Don Kirkby  
DATE CREATED: Jan 29, 1999  
CALLED BY: ReportParams  
MOD HISTORY:  
Name    Date        Comments  
Don K Apr 12 1999 Stopped checking resnet flag on location  
Oct 29 - Moved data conversion code with NULLIF out of the where clause   
Roy he  Apr 02 2004 Modified to include Local Company Only Logic    
Kenneth Wong Jun 15 2005 Office with 0 rental location will print all owning companies
*/  
CREATE PROCEDURE [dbo].[GetRptLimitedCompany] --'B-32 Calgary Head Office'  
 @LocName varchar(25)  
AS  
 DECLARE @LocId smallint  
        DECLARE @CompanyID smallint  
 DECLARE @LocalCompanyOnly bit  
  
 SELECT @LocName = NULLIF(@LocName, '')  
  

 SELECT @LocId =location_id, @CompanyID=Owning_Company_ID,@LocalCompanyOnly=LocalCompanyOnly   FROM location  
  WHERE location =@LocName  

IF (SELECT rental_location FROM location WHERE location_id = @locid)=0 BEGIN
	SELECT [name],  owning_company_id  
   	FROM owning_company  
  	WHERE delete_flag = 0  
	ORDER BY [name]
END ELSE BEGIN
	SELECT [name],  owning_company_id  
   	FROM owning_company  
  	WHERE delete_flag = 0  AND owning_company_id IN  
  	(  	SELECT owning_company_id  
    	   	FROM location  
   	   	WHERE delete_flag = 0  
 		AND  (((   
    	  	SELECT loc2.rental_location  
       		FROM location loc2  
  		WHERE loc2.location_id = @Locid
        	) = 0 ) 
  		OR location_id = @Locid
   		)  
  	)  
  	ORDER  
     	BY [name]
END  



GO
