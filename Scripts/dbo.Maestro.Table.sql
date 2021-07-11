USE [GISData]
GO
/****** Object:  Table [dbo].[Maestro]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Maestro](
	[Maestro_ID] [int] IDENTITY(1,1) NOT NULL,
	[GIS_Process_Date] [datetime] NOT NULL,
	[Update_GIS_Indicator] [bit] NOT NULL,
	[Transaction_Date] [datetime] NULL,
	[Sequence_Number] [int] NULL,
	[Confirmation_Number] [int] NULL,
	[Maestro_Data] [text] NULL,
	[Foreign_Confirm_Number] [varchar](20) NULL,
 CONSTRAINT [PK_Maestro] PRIMARY KEY CLUSTERED 
(
	[Maestro_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Maestro_7_1326731879__K6_K4]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Maestro_7_1326731879__K6_K4] ON [dbo].[Maestro]
(
	[Confirmation_Number] ASC,
	[Transaction_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Maestro] ADD  CONSTRAINT [DF__Maestro__Update___55374011]  DEFAULT (0) FOR [Update_GIS_Indicator]
GO
