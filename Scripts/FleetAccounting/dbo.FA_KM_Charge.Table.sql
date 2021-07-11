USE [GISData]
GO
/****** Object:  Table [dbo].[FA_KM_Charge]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_KM_Charge](
	[KM_Charge_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Agreement_Year] [char](4) NULL,
	[Purchase_Cycle] [nchar](1) NULL,
	[Manufacturer] [smallint] NULL,
	[Program] [bit] NULL,
	[KM_Start] [int] NULL,
	[KM_End] [int] NULL,
	[KM_Charge] [decimal](9, 9) NULL,
 CONSTRAINT [PK_FA_KM_Charge] PRIMARY KEY CLUSTERED 
(
	[KM_Charge_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
