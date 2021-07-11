USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Shops]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Shops](
	[Rate_Shop_id] [int] IDENTITY(1,1) NOT NULL,
	[Batch_ID] [int] NOT NULL,
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
	[WS_CarCategory] [varchar](50) NULL,
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
	[CachedPath] [varchar](200) NULL,
 CONSTRAINT [PK_Rate_Shops] PRIMARY KEY CLUSTERED 
(
	[Rate_Shop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
