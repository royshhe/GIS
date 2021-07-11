USE [GISData]
GO
/****** Object:  Table [dbo].[Insurance_Transfer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurance_Transfer](
	[Contract_Number] [int] NOT NULL,
	[Company_Name] [varchar](20) NOT NULL,
	[Collision_Deductible] [decimal](9, 2) NULL,
	[Comprehensive_Deductible] [decimal](9, 2) NULL,
	[Expiry] [datetime] NOT NULL,
	[Vehicle_Manufacturer] [varchar](10) NOT NULL,
	[Vehicle_Model_Name] [varchar](25) NOT NULL,
	[Vehicle_Year] [smallint] NOT NULL,
	[Vehicle_Licence_Plate] [varchar](10) NOT NULL,
	[Last_Change_On] [datetime] NOT NULL,
	[Last_Change_By] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Insurance_Transfer] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Insurance_Transfer]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract08] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Insurance_Transfer] CHECK CONSTRAINT [FK_Contract08]
GO
