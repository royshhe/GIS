USE [GISData]
GO
/****** Object:  Table [dbo].[submission]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[submission](
	[Renting_COUNTRY] [nvarchar](255) NULL,
	[VENDOR_NUMBER] [nvarchar](255) NULL,
	[RENTING_LOCATION] [float] NULL,
	[WIZARD_STATION] [float] NULL,
	[RENTING_CITY] [nvarchar](255) NULL,
	[CHECKOUT_DATE] [smalldatetime] NULL,
	[ARC/IATA_NUMBER] [float] NULL,
	[RENTER_NAME] [nvarchar](255) NULL,
	[CONFIRMATION_NUMBER] [nvarchar](255) NULL,
	[R/A_NUMBER] [nvarchar](255) NULL,
	[T&M_AMOUNT] [float] NULL,
	[COMM_AMOUNT] [float] NULL,
	[TAXES_PAID] [float] NULL
) ON [PRIMARY]
GO
