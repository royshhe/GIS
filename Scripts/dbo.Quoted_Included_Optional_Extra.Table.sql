USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Included_Optional_Extra]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Included_Optional_Extra](
	[Quoted_Rate_ID] [int] NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[LDW_Deductible] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Quoted_Included_Optional_Ex] PRIMARY KEY CLUSTERED 
(
	[Quoted_Rate_ID] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Quoted_Included_Optional_Extra]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra06] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Quoted_Included_Optional_Extra] CHECK CONSTRAINT [FK_Optional_Extra06]
GO
ALTER TABLE [dbo].[Quoted_Included_Optional_Extra]  WITH CHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate1] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Quoted_Included_Optional_Extra] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate1]
GO
