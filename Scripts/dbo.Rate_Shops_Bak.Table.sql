USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Shops_Bak]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Shops_Bak](
	[WebsiteURL] [varchar](80) NULL,
	[PickUpLocation] [varchar](20) NULL,
	[PickUpLocationAddress] [varchar](100) NULL,
	[PickUpLocationType] [varchar](20) NULL,
	[DropOffLocation] [varchar](20) NULL,
	[DropOffLocationAddress] [varchar](100) NULL,
	[DropOffLocationType] [varchar](20) NULL,
	[PickUpDateTime] [datetime] NULL,
	[DropOffDateTime] [datetime] NULL,
	[LOR] [int] NULL,
	[Prepay Indicator] [bit] NULL,
	[SIPPcode] [varchar](20) NULL,
	[CarTypeCode] [varchar](20) NULL,
	[PG_VendorCode] [varchar](20) NULL,
	[VendorName] [varchar](80) NULL,
	[Currency] [varchar](20) NULL,
	[Inclusive_Rate] [decimal](9, 2) NULL,
	[Rate_Type] [varchar](20) NULL,
	[Rate_Amount] [decimal](9, 2) NULL,
	[Rate_Category] [varchar](20) NULL,
	[Payment_Type] [varchar](20) NULL,
	[DiscountCode] [varchar](20) NULL,
	[ExclusiveRate] [decimal](2, 2) NULL,
	[Mileage] [varchar](20) NULL,
	[MileCharge] [decimal](9, 2) NULL,
	[DropFee] [decimal](9, 2) NULL,
	[ExtraDay] [decimal](9, 2) NULL,
	[HourCharge] [decimal](9, 2) NULL,
	[TaxAmount] [decimal](9, 2) NULL,
	[FuelCharges] [decimal](9, 2) NULL,
	[PassThrough] [decimal](9, 2) NULL,
	[WS_CarCategory] [varchar](20) NULL,
	[PG_CarCategory] [varchar](20) NULL,
	[CarName] [varchar](150) NULL,
	[SeatingCapacity] [int] NULL,
	[SeatingCapacityChild] [int] NULL,
	[DoorsInformation] [int] NULL,
	[WheelDriveType] [varchar](100) NULL,
	[TransmissionType] [varchar](100) NULL,
	[AirConditioner] [varchar](20) NULL,
	[FuelType] [varchar](50) NULL,
	[Luggage] [int] NULL,
	[ShopTime] [datetime] NULL,
	[CachedPath] [varchar](200) NULL
) ON [PRIMARY]
GO
