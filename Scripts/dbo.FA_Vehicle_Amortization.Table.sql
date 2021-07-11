USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Vehicle_Amortization]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Vehicle_Amortization](
	[Unit_Number] [int] NOT NULL,
	[AMO_Month] [datetime] NOT NULL,
	[AMO_Amount] [decimal](9, 2) NULL,
	[Dep_Credit] [decimal](9, 2) NULL,
	[InService_Months] [int] NULL,
	[Balance] [decimal](10, 2) NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_FA_Vehicle_Amortization] PRIMARY KEY CLUSTERED 
(
	[AMO_Month] ASC,
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Vehicle_Amortization]  WITH NOCHECK ADD  CONSTRAINT [FK_FA_Vehicle_Amortization_Vehicle] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[FA_Vehicle_Amortization] CHECK CONSTRAINT [FK_FA_Vehicle_Amortization_Vehicle]
GO
