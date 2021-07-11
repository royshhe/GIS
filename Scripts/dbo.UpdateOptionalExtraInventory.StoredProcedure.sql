USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOptionalExtraInventory]    Script Date: 2021-07-10 1:50:50 PM ******/
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


create PROCEDURE [dbo].[UpdateOptionalExtraInventory]
	@UnitNumber Varchar(12),
	@OptionalExtraType Varchar(20),
	@LocationID varchar(5),
	@SerialNumber varchar(12)
AS

	Update     Optional_Extra_Inventory
	SET     Serial_Number = @SerialNumber,
			Owning_Location = Convert(smallint, NULLIF(@LocationID,''))
	WHERE	Unit_Number = @UnitNumber
			and Optional_Extra_Type= @OptionalExtraType

  RETURN @@ROWCOUNT
GO
