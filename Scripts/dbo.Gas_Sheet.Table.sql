USE [GISData]
GO
/****** Object:  Table [dbo].[Gas_Sheet]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gas_Sheet](
	[Unit_Number] [int] NOT NULL,
	[Gas_Fill_Date] [datetime] NOT NULL,
	[KM_Reading] [int] NULL,
	[Fuel_Added_Litters] [decimal](5, 2) NULL,
	[Fuel_Added_Dollar_Amt] [decimal](5, 2) NULL,
	[Contract_Number] [int] NULL,
	[Movement_Type] [varchar](30) NULL,
 CONSTRAINT [PK_Gas_Sheet] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Gas_Fill_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
