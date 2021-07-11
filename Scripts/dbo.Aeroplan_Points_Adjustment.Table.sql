USE [GISData]
GO
/****** Object:  Table [dbo].[Aeroplan_Points_Adjustment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aeroplan_Points_Adjustment](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Missing_Number] [varchar](50) NULL,
	[Missing_Points] [int] NULL,
	[Processed_By] [varchar](50) NULL,
	[Processed_On] [datetime] NULL,
 CONSTRAINT [PK_Aeroplan_Points_Adjustment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
