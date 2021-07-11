USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Rates_Analysis]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Rates_Analysis](
	[Confirmation_Number] [varchar](13) NULL,
	[Contract_Number] [int] NULL,
	[Vehicle_Class_Name] [varchar](25) NOT NULL,
	[Sub_Vehicle_Class] [varchar](25) NULL,
	[PickUpLoc] [varchar](25) NOT NULL,
	[DropOffLoc] [varchar](25) NOT NULL,
	[Pick_Up_On] [datetime] NULL,
	[Drop_Off_On] [datetime] NULL,
	[TransTime] [datetime] NULL,
	[ResCancelTime] [datetime] NULL,
	[ResStatus] [char](1) NULL,
	[ContractStatus] [char](2) NULL,
	[Contract_Rental_Days] [numeric](17, 6) NULL,
	[BCD_Number] [varchar](25) NULL,
	[IATA_Number] [varchar](10) NULL,
	[Rate_Name] [varchar](25) NULL,
	[Rate_Level] [char](1) NULL,
	[Daily_rate] [decimal](38, 2) NULL,
	[Addnl_Daily_rate] [decimal](38, 2) NULL,
	[Weekly_rate] [decimal](38, 2) NULL,
	[Hourly_rate] [decimal](38, 2) NULL,
	[Monthly_rate] [decimal](38, 2) NULL,
	[Rate_Type] [varchar](20) NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL
) ON [PRIMARY]
GO
