USE [GISData]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[Location_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Location] [varchar](25) NOT NULL,
	[Owning_Company_ID] [smallint] NOT NULL,
	[Hub_ID] [char](25) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NOT NULL,
	[City] [varchar](25) NOT NULL,
	[Province] [varchar](25) NOT NULL,
	[Postal_Code] [varchar](10) NOT NULL,
	[Fax_Number] [varchar](31) NOT NULL,
	[Phone_Number] [varchar](31) NOT NULL,
	[Grace_Period] [smallint] NULL,
	[Manager] [varchar](25) NOT NULL,
	[Remarks] [varchar](255) NULL,
	[Address_Description] [varchar](130) NOT NULL,
	[Hours_of_Service_Description] [varchar](100) NULL,
	[Corporate_Location_ID] [smallint] NULL,
	[Percentage_Fee] [decimal](5, 2) NULL,
	[Flat_Fee] [decimal](7, 2) NULL,
	[GIS_Member] [bit] NOT NULL,
	[Fuel_Price_Per_Liter] [decimal](7, 4) NULL,
	[Fuel_Price_Per_Liter_Diesel] [decimal](7, 4) NULL,
	[FPO_Fuel_Price_Per_Liter] [decimal](7, 4) NULL,
	[FPO_Fuel_Price_Per_Liter_Dsel] [decimal](7, 4) NULL,
	[Default_Unauthorized_charge] [decimal](7, 2) NULL,
	[Rental_Location] [bit] NOT NULL,
	[ResNet] [bit] NOT NULL,
	[Delete_Flag] [bit] NOT NULL,
	[Fee_Type] [varchar](10) NULL,
	[Mnemonic_Code] [char](4) NULL,
	[Platinum_Territory_Code] [varchar](8) NULL,
	[AR_Forced_Charge_Account] [varchar](8) NULL,
	[GL_Fees_Payable_Clear_Account] [varchar](32) NULL,
	[Version] [smallint] NOT NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
	[TruckInv_Last_Updated_By] [varchar](20) NOT NULL,
	[TruckInv_Last_Updated_On] [datetime] NOT NULL,
	[LicenseFeePerDay] [decimal](7, 2) NULL,
	[LicenseFeePercentage] [decimal](5, 2) NULL,
	[LicenseFeeFlat] [decimal](7, 2) NULL,
	[AllowResForOther] [bit] NULL,
	[BroadcastMssg] [varchar](1000) NULL,
	[LocationName] [varchar](50) NULL,
	[SearchKeyWord] [varchar](300) NULL,
	[IsAirportLocation] [bit] NULL,
	[LocationDescription] [varchar](200) NULL,
	[Country] [varchar](50) NULL,
	[StationNumber] [char](10) NULL,
	[CounterCode] [char](10) NULL,
	[GDSCode] [char](10) NULL,
	[LocalHubOnly] [bit] NOT NULL,
	[LocalCompanyOnly] [bit] NOT NULL,
	[DBRCode] [varchar](20) NULL,
	[IB_Zone] [char](10) NULL,
	[Merchant_ID] [varchar](20) NULL,
	[Sell_Online] [bit] NULL,
	[CSA] [bit] NULL,
	[Acctg_Segment] [varchar](15) NULL,
	[Email_Hour_Description] [varchar](100) NULL,
	[Payment_Processing] [bit] NULL,
	[IBX_Code] [char](10) NULL,
	[SunnyCloudyLocName] [varchar](50) NULL,
	[SunnyCloudyCode] [char](1) NULL,
	[Merchant_Name] [varchar](50) NULL,
	[TK_CounterCode] [char](10) NULL,
	[TK_Mnemonic_Code] [char](4) NULL,
	[TK_StationNumber] [char](10) NULL,
	[TK_DBRCode] [char](10) NULL,
	[Truck_Location] [bit] NOT NULL,
	[Car_Location] [bit] NOT NULL,
	[District] [varchar](30) NULL,
	[OnlineImage_big] [nvarchar](100) NULL,
	[OnlineImage_small] [nvarchar](100) NULL,
	[MapImage_small] [nvarchar](100) NULL,
	[Latitude] [decimal](10, 7) NULL,
	[Longitude] [decimal](10, 7) NULL,
	[Nearby_Airport_location] [int] NULL,
	[Car_StationNumber] [varchar](10) NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Location1] UNIQUE NONCLUSTERED 
(
	[Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Location_5_496929042__K1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Location_5_496929042__K1] ON [dbo].[Location]
(
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Location_5_496929042__K2_K1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Location_5_496929042__K2_K1] ON [dbo].[Location]
(
	[Location] ASC,
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_Location1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Location1] ON [dbo].[Location]
(
	[Owning_Company_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [UC_Location2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [UC_Location2] ON [dbo].[Location]
(
	[Corporate_Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF__Location__Delete__0EA8C04A]  DEFAULT (0) FOR [Delete_Flag]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Version]  DEFAULT (0) FOR [Version]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_LocalHubOnly]  DEFAULT (0) FOR [LocalHubOnly]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_LocalCompanyOnly]  DEFAULT (0) FOR [LocalCompanyOnly]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Truck_Location]  DEFAULT (0) FOR [Truck_Location]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DFX_089C8138]  DEFAULT (0) FOR [Car_Location]
GO
