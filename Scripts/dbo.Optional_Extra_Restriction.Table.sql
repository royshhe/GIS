USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Restriction]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Restriction](
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
 CONSTRAINT [PK_Optional_Extra_Restriction] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Class_Code] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Optional_Extra_Restriction]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra01] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Optional_Extra_Restriction] CHECK CONSTRAINT [FK_Optional_Extra01]
GO
ALTER TABLE [dbo].[Optional_Extra_Restriction]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class2] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Optional_Extra_Restriction] CHECK CONSTRAINT [FK_Vehicle_Class2]
GO
