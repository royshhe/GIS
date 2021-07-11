USE [GISData]
GO
/****** Object:  Table [dbo].[LDW_Deductible]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LDW_Deductible](
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[LDW_Deductible] [decimal](9, 2) NOT NULL,
	[Default_Flag] [bit] NULL,
 CONSTRAINT [PK_LDW_Deductible] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Class_Code] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LDW_Deductible]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra03] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[LDW_Deductible] CHECK CONSTRAINT [FK_Optional_Extra03]
GO
ALTER TABLE [dbo].[LDW_Deductible]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class9] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[LDW_Deductible] CHECK CONSTRAINT [FK_Vehicle_Class9]
GO
