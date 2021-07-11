USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLResVehClasses]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetOLResVehClasses] -- '20','20','2009-09-06','1'
	@PickupLocId Varchar(5),
	@DropOffLocID Varchar(5),
	@CurrDate Varchar(24),
	@CSAOnly Varchar(1)
	
AS
	DECLARE	@dLastDatetime Datetime
	DECLARE @nLocId SmallInt
	DECLARE @nDropLocId SmallInt
	DECLARE	@dCurrDate DateTime
	DECLARE @bCSAOnly  bit

	--ECLARE 	@VehClassCode varchar(3)

	SELECT	@nLocId = Convert(SmallInt, NULLIF(@PickupLocId,''))
	SELECT	@nDropLocId = Convert(SmallInt, NULLIF(@DropOffLocID,''))
	SELECT	@dCurrDate = Convert(DateTime, NULLIF(@CurrDate,''))
	SELECT  @bCSAOnly = Convert(Bit, NULLIF(@CSAOnly,''))


	--if @ResVehClassCode = ''
		--select @VehClassCode = null
	--else
		--select  @ResVehClassCode = @VehClassCode
	
	IF @CurrDate = ''
		SELECT @CurrDate = Convert(Varchar(24), Getdate(), 113)
	SELECT @dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')

 
	-- return list of all vehicle classes valid for @LocId on @CurrDate	
	SELECT	(Case When @bCSAOnly =1 Then VC.Alias Else VC.Vehicle_Class_Name End) As Class_Name, LocVC.Vehicle_Class_Code,
		VC.Vehicle_Type_ID, VC.Description,VC.Minimum_Age, VC.Deposit_Amount, 
		ISNULL(LT.Value,'0') AS PVRT_Exempt, VC.PST
	FROM	Vehicle_Class VC
		JOIN Location_Vehicle_Class LocVC
		  ON VC.Vehicle_Class_Code = LocVC.Vehicle_Class_Code
		LEFT OUTER JOIN Lookup_Table LT
		  ON VC.Vehicle_Class_Code = LT.Code
		 AND LT.Category = 'PVRT Exempt'
	WHERE	@dCurrDate
			BETWEEN Valid_From AND ISNULL(Valid_To, @dLastDatetime)
	AND	LocVC.Location_ID = @nLocId 
        AND     VC.SellOnline=1 And (VC.CSA=@bCSAOnly or @bCSAOnly=0)
        -- One Way Block (Between Hubs?)
	And VC.Vehicle_Class_Code not in 
           (SELECT  VCBlkOut.Vehicle_Class_Code
           FROM         dbo.Location DropOffLocation INNER JOIN
                    VehicleClassBlackOut VCBlkOut ON DropOffLocation.Hub_ID =VCBlkOut.DestinationHubID
		where (
 			( @dCurrDate BETWEEN VCBlkOut.BlackoutStartDate AND ISNULL(VCBlkOut.BlackoutEndDate, @dLastDatetime))
		 	and VCBlkOut.Location_id=@nLocId 
			and DropOffLocation.Location_id=@DropOffLocID)

	)
		RETURN @@ROWCOUNT
GO
