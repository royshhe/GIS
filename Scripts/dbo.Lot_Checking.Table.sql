USE [GISData]
GO
/****** Object:  Table [dbo].[Lot_Checking]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lot_Checking](
	[Unit_number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[MVA_Number] [varchar](20) NULL,
	[Location_ID] [smallint] NULL,
	[Checking_Time] [datetime] NULL,
 CONSTRAINT [PK_Lot_Checking] PRIMARY KEY CLUSTERED 
(
	[Unit_number] ASC,
	[RBR_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
