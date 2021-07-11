USE [GISData]
GO
/****** Object:  Table [dbo].[Toll_Charge]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Toll_Charge](
	[Toll_Charge_ID] [int] IDENTITY(1,1) NOT NULL,
	[Toll_Charge_Date] [datetime] NOT NULL,
	[Charge_Amount] [decimal](9, 2) NOT NULL,
	[Licence_Plate] [varchar](10) NOT NULL,
	[Direction] [varchar](50) NULL,
	[Vehicle_Class] [varchar](50) NULL,
	[Issuer] [varchar](10) NOT NULL,
	[Processed] [bit] NOT NULL,
	[Email_Sent] [bit] NULL,
	[Business_Transaction_ID] [int] NULL,
	[Decal] [varchar](15) NULL,
	[Nick_Name] [varchar](20) NULL,
	[Bridge] [varchar](15) NULL,
	[Tolling_Method] [varchar](50) NULL,
 CONSTRAINT [PK_Toll_Charge] PRIMARY KEY CLUSTERED 
(
	[Toll_Charge_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Toll_Charge_5_1080599138__K7_K4_K2_K3]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Toll_Charge_5_1080599138__K7_K4_K2_K3] ON [dbo].[Toll_Charge]
(
	[Issuer] ASC,
	[Licence_Plate] ASC,
	[Toll_Charge_Date] ASC,
	[Charge_Amount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Toll_Charge_5_1080599138__K8]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Toll_Charge_5_1080599138__K8] ON [dbo].[Toll_Charge]
(
	[Processed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Toll_Charge]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Toll_Charge] ON [dbo].[Toll_Charge]
(
	[Licence_Plate] ASC,
	[Toll_Charge_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Toll_Charge] ADD  CONSTRAINT [DF_Toll_Charge_Issuer]  DEFAULT ('T3') FOR [Issuer]
GO
ALTER TABLE [dbo].[Toll_Charge] ADD  CONSTRAINT [DF_Toll_Charge_Processed]  DEFAULT (0) FOR [Processed]
GO
ALTER TABLE [dbo].[Toll_Charge] ADD  CONSTRAINT [DF_Toll_Charge_Email_Sent]  DEFAULT (0) FOR [Email_Sent]
GO
