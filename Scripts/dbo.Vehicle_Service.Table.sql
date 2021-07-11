USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Service]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Service](
	[Unit_Number] [int] NOT NULL,
	[Service_Performed_On] [datetime] NOT NULL,
	[Condition_Status] [char](1) NOT NULL,
	[Km_Reading] [int] NOT NULL,
	[Fuel_Added_Dollars] [decimal](7, 2) NULL,
	[Fuel_Added_Litres] [int] NULL,
	[Fuel_Tank_Level] [char](6) NULL,
	[Litres_Remaining] [int] NULL,
	[Smoking] [bit] NOT NULL,
 CONSTRAINT [PK_Vehicle_Service] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Service_Performed_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Service]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle4] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Service] CHECK CONSTRAINT [FK_Vehicle4]
GO
