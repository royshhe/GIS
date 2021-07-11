USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSCommforLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* 
** Author: Linda Qu 							  **
** Date: Dec 22, 1999                                         		  **
** Purpose:  Lists any contracts at particular location with Location Follow-Up comment **    
** Parameter: @PickUpLocName   the name of the location                   **           
*/

CREATE PROCEDURE [dbo].[GetSCommforLoc] 
       @PickUpLocName varchar(25)     
AS
SET NOCOUNT ON

DECLARE @pickuplocid SMALLINT

SELECT @pickuplocid =Location_ID  FROM Location where Location=@PickUpLocName
IF @pickuplocid IS NULL 
BEGIN 
   PRINT 'Wrong Location Name,Please re-run this report with the valid location name.'
END
ELSE 
BEGIN

	SELECT 'PickUpLocation'=loc1.location,'Contract#'=contract_number,'DropOffLocation'=loc2.location,'DropOffTime'=drop_off_on
	FROM Contract con,Location loc1,Location loc2 
	WHERE con.contract_number in 
	(SELECT contract_number FROM contract_print_comment
	WHERE standard_print_comment_id='5')
        AND con.status in ('OP','CO')
	AND con.pick_up_location_id=@pickuplocid
	AND loc1.location_id=con.pick_up_location_id
	AND loc2.location_id=con.drop_off_location_id
END
SET NOCOUNT OFF





GO
