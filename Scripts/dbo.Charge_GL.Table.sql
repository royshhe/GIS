USE [GISData]
GO
/****** Object:  Table [dbo].[Charge_GL]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Charge_GL](
	[Charge_Type_ID] [int] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[GL_Revenue_Account] [varchar](32) NOT NULL,
 CONSTRAINT [PK_Charge_GL] PRIMARY KEY CLUSTERED 
(
	[Charge_Type_ID] ASC,
	[Vehicle_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Charge_GL]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Type2] FOREIGN KEY([Vehicle_Type_ID])
REFERENCES [dbo].[Vehicle_Type] ([Vehicle_Type_ID])
GO
ALTER TABLE [dbo].[Charge_GL] CHECK CONSTRAINT [FK_Vehicle_Type2]
GO
