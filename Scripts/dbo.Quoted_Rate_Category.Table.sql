USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Rate_Category]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Rate_Category](
	[Quoted_Rate_ID] [int] NOT NULL,
	[Maestro_Rate_Category_Code] [char](2) NOT NULL,
 CONSTRAINT [PK_Quoted_Rate_Category] PRIMARY KEY CLUSTERED 
(
	[Quoted_Rate_ID] ASC,
	[Maestro_Rate_Category_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Quoted_Rate_Category]  WITH CHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate4] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Quoted_Rate_Category] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate4]
GO
