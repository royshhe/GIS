USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Shop_Settings]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Shop_Settings](
	[Vendor] [varchar](20) NOT NULL,
	[Location] [varchar](20) NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[ERF_Per_Day] [decimal](9, 2) NULL,
	[ERF_Flat] [decimal](9, 2) NULL,
	[VLF] [decimal](9, 2) NULL,
	[PLS] [decimal](9, 2) NULL,
	[PVRT] [decimal](9, 2) NULL,
	[Vehicle_Maint_Fee] [decimal](9, 2) NULL,
	[Parking_Surcharge] [decimal](9, 2) NULL,
	[ERF_GSTable] [bit] NOT NULL,
	[VLF_GSTable] [bit] NOT NULL,
	[PLS_GSTable] [bit] NOT NULL,
	[PVRT_GSTable] [bit] NOT NULL,
	[Vehicle_Maint_Fee_GSTable] [bit] NULL,
	[Parking_Surcharge_GSTable] [bit] NULL,
	[ERF_PSTable] [bit] NOT NULL,
	[VLF_PSTable] [bit] NOT NULL,
	[PLS_PSTable] [bit] NOT NULL,
	[PVRT_PSTable] [bit] NOT NULL,
	[Vehicle_Maint_Fee_PSTable] [bit] NULL,
	[Parking_Surcharge_PSTable] [bit] NULL,
	[ERF_APFee] [bit] NOT NULL,
	[VLF_APFee] [bit] NOT NULL,
 CONSTRAINT [PK_Rate_Shop_Settings] PRIMARY KEY CLUSTERED 
(
	[Vendor] ASC,
	[Location] ASC,
	[Effective_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_ERF_GSTable]  DEFAULT (1) FOR [ERF_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_VLF_GSTable]  DEFAULT (1) FOR [VLF_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_PLS_GSTable]  DEFAULT (1) FOR [PLS_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_PVRT_GSTable]  DEFAULT (1) FOR [PVRT_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_Vehicle_Maint_Fee_GSTable]  DEFAULT (0) FOR [Vehicle_Maint_Fee_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_Parking_Surcharge_GSTable]  DEFAULT (1) FOR [Parking_Surcharge_GSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_ERF_PSTable]  DEFAULT (1) FOR [ERF_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_VLF_PSTable]  DEFAULT (1) FOR [VLF_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_PLS_PSTable]  DEFAULT (1) FOR [PLS_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_PVRT_PSTable]  DEFAULT (0) FOR [PVRT_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_Vehicle_Maint_Fee_PSTable]  DEFAULT (1) FOR [Vehicle_Maint_Fee_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_Parking_Surcharge_PSTable]  DEFAULT (1) FOR [Parking_Surcharge_PSTable]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_ERF_APFee]  DEFAULT (1) FOR [ERF_APFee]
GO
ALTER TABLE [dbo].[Rate_Shop_Settings] ADD  CONSTRAINT [DF_Rate_Shop_Settings_VLF_APFee]  DEFAULT (1) FOR [VLF_APFee]
GO
