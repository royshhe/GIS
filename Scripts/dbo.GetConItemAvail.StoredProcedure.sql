USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConItemAvail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Check the Availability of the unit see if the item is on rent in any rental--
CREATE Procedure [dbo].[GetConItemAvail]  --59, '1001'
	@OptionalExtraID Varchar(20),
	@UnitNum Varchar(20)
AS

DECLARE @iOptionalExtraID Int
DECLARE @iLocID Int
DEClARE @iCounterInv Int
DECLARE @iCurrRANumber Int
DECLARE @iCurLoc Int
Declare @dMoveOut  Datetime


Select @UnitNum=  NULLIF(@UnitNum,'') 
Select @iOptionalExtraID=Convert(Int, NULLIF(@OptionalExtraID,''))
--Select @iLocID=Convert(Int, NULLIF(@LocationID,''))

select @iCounterInv=count(*) from  Optional_Extra_Inventory
where  Optional_Extra_ID=@iOptionalExtraID and unit_number=  @UnitNum   And Current_Item_Status='d'   and  deleted_flag=0

--select * from   Optional_Extra_Inventory

SELECT @iCurrRANumber=Max(dbo.Contract_Optional_Extra.Contract_Number)
FROM  dbo.Contract_Optional_Extra 
	INNER JOIN dbo.Optional_Extra_Inventory 
            ON dbo.Contract_Optional_Extra.Unit_Number = dbo.Optional_Extra_Inventory.Unit_Number 
            AND dbo.Contract_Optional_Extra.Optional_Extra_ID = dbo.Optional_Extra_Inventory.Optional_Extra_ID
    INNER JOIN dbo.Contract On dbo.Contract_Optional_Extra.Contract_number=dbo.Contract.Contract_number
WHERE (dbo.Contract_Optional_Extra.Optional_Extra_ID = @iOptionalExtraID) 
	AND (dbo.Contract_Optional_Extra.Unit_Number = @UnitNum) 
	AND (dbo.Contract_Optional_Extra.Status = 'CO')
	And Contract_Optional_Extra.Termination_Date>getdate()
	And dbo.Contract.Status not in ('VD', 'CA')
	
 
 
 
Select @dMoveOut=Max(MV.Date_Out)  
From
(
SELECT  max(Rent_From) Date_Out
FROM    dbo.Contract_Optional_Extra
where	Optional_Extra_ID=@iOptionalExtraID and Unit_number=@UnitNum	and Termination_Date>getdate()
Union
SELECT Max(Movement_Out)  Date_Out
FROM  dbo.Optional_Extra_Item_Movement
where	Optional_Extra_ID=@iOptionalExtraID and Unit_number=@UnitNum
) MV

     

 Select Top 1 @iCurLoc= VLoc.CurrentLoc From 
(	SELECT (Case when Status='CO' Then Sold_At_Location_ID
	  			 when Status='CI' Then Return_Location_ID 
			End) CurrentLoc
	FROM    dbo.Contract_Optional_Extra
	where	Optional_Extra_ID=@iOptionalExtraID and Unit_number=@UnitNum	and Termination_Date>getdate()
	And Rent_from =@dMoveOut
	Union
	Select
	(Case When Movement_In is null Then Sending_Location_ID 
		  Else Receiving_Location_ID 
	End) CurrentLoc
	FROM  dbo.Optional_Extra_Item_Movement
	where	Optional_Extra_ID=@iOptionalExtraID and Unit_number=@UnitNum
	And Movement_Out=@dMoveOut

)  VLoc


Select @iCounterInv as ItemCounter,  @iCurrRANumber as ContractNumber, @iCurLoc as CurrentLocation
GO
