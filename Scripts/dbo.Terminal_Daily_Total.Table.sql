USE [GISData]
GO
/****** Object:  Table [dbo].[Terminal_Daily_Total]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Terminal_Daily_Total](
	[Terminal_ID] [varchar](20) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Eigen_CCT_Code] [char](2) NOT NULL,
	[Eigen_Purchase_Amount] [decimal](9, 2) NULL,
	[Eigen_Purchase_Count] [int] NULL,
	[Budget_Purchase_Amount] [decimal](9, 2) NULL,
	[Budget_Purchase_Count] [int] NULL,
	[Eigen_Return_Amount] [decimal](9, 2) NULL,
	[Eigen_Return_Count] [int] NULL,
	[Budget_Return_Amount] [decimal](9, 2) NULL,
	[Budget_Return_Count] [int] NULL,
 CONSTRAINT [PK_Terminal_Daily_Total] PRIMARY KEY CLUSTERED 
(
	[Terminal_ID] ASC,
	[RBR_Date] ASC,
	[Eigen_CCT_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Terminal_Daily_Total]  WITH CHECK ADD  CONSTRAINT [FK_RBR_Date4] FOREIGN KEY([RBR_Date])
REFERENCES [dbo].[RBR_Date] ([RBR_Date])
GO
ALTER TABLE [dbo].[Terminal_Daily_Total] CHECK CONSTRAINT [FK_RBR_Date4]
GO
ALTER TABLE [dbo].[Terminal_Daily_Total]  WITH CHECK ADD  CONSTRAINT [FK_Terminal1] FOREIGN KEY([Terminal_ID])
REFERENCES [dbo].[Terminal] ([Terminal_ID])
GO
ALTER TABLE [dbo].[Terminal_Daily_Total] CHECK CONSTRAINT [FK_Terminal1]
GO
