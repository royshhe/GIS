USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra](
	[Optional_Extra_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Optional_Extra] [varchar](35) NOT NULL,
	[Maximum_Quantity] [smallint] NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[Delete_Flag] [bit] NOT NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
	[Alias] [varchar](50) NULL,
	[SellOnline] [bit] NOT NULL,
	[Unit_Required] [bit] NULL,
	[Charge_Type_ID] [char](2) NULL,
	[Optional_Extra_Name] [varchar](50) NULL,
	[Description] [varchar](100) NULL,
	[CPROD-EQUIPMENT-CD] [char](10) NULL,
	[Addendum_Required] [bit] NULL,
	[Online_Display_Order] [smallint] NULL,
 CONSTRAINT [PK_Optional_Extra] PRIMARY KEY CLUSTERED 
(
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UC_Optional_Extra1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UC_Optional_Extra1] ON [dbo].[Optional_Extra]
(
	[Optional_Extra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Optional_Extra] ADD  CONSTRAINT [DF__Optional___Delet__758F010A]  DEFAULT (0) FOR [Delete_Flag]
GO
ALTER TABLE [dbo].[Optional_Extra] ADD  CONSTRAINT [SellOnline_default]  DEFAULT (0) FOR [SellOnline]
GO
