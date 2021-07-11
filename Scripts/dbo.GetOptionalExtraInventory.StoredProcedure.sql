USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptionalExtraInventory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PROCEDURE NAME: GetVehServOption
PURPOSE: To return vehicle options for vehicle service screen 
AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Vehicle Service
REQUIRES:
ENSURES: 
MOD HISTORY:
Name    Date        Comments
Don K - May 6 1999 - Made @UnitNum match foreign or local unit number
6/07/99 - cpy modified - added current location id and current rental status
CPY - Nov 17 1999 - removed matching on foreign unit number
*/


create PROCEDURE [dbo].[GetOptionalExtraInventory]
	@LocationID varchar(5),
	@OptionalExtraType varchar(30),
	@UnitNumber varchar(12),
	@SerialNumber varchar(12)
AS
	DECLARE  @tmpLocID varchar(5)	

	if @LocationID = '*'
		BEGIN
			SELECT @tmpLocID='0'
			END
	else
		BEGIN
			SELECT @tmpLocID = @LocationID
		END 


	SELECT  *
	FROM    Optional_Extra_Inventory
	WHERE	(@LocationID = '*' or Owning_Location = @tmpLocID)
		and (@OptionalExtraType = '*' or Optional_Extra_Type = @OptionalExtraType)
	    and (@UnitNumber = '*' or Unit_Number like '%'+ @UnitNumber + '%')
		and (@SerialNumber = '*' or Serial_Number like '%'+ @SerialNumber + '%')
		and deleted_flag = 0
	--Or	Foreign_Vehicle_Unit_Number = @UnitNum

  RETURN @@ROWCOUNT
GO
