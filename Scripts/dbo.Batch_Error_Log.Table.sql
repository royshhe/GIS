USE [GISData]
GO
/****** Object:  Table [dbo].[Batch_Error_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Batch_Error_Log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Process_Code] [char](10) NOT NULL,
	[Process_Date] [datetime] NOT NULL,
	[Batch_Start_Date] [datetime] NOT NULL,
	[Error_Number] [int] NOT NULL,
	[Data_1] [varchar](255) NULL,
	[Data_2] [varchar](255) NULL,
	[Maestro_ID] [int] NULL,
	[Data_3] [varchar](255) NULL,
 CONSTRAINT [PK_Batch_Error_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Error_Log]  WITH CHECK ADD  CONSTRAINT [FK_Batch_Error_Message1] FOREIGN KEY([Error_Number])
REFERENCES [dbo].[Batch_Error_Message] ([Error_Number])
GO
ALTER TABLE [dbo].[Batch_Error_Log] CHECK CONSTRAINT [FK_Batch_Error_Message1]
GO
ALTER TABLE [dbo].[Batch_Error_Log]  WITH NOCHECK ADD  CONSTRAINT [FK_Maestro1] FOREIGN KEY([Maestro_ID])
REFERENCES [dbo].[Maestro] ([Maestro_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Batch_Error_Log] NOCHECK CONSTRAINT [FK_Maestro1]
GO
