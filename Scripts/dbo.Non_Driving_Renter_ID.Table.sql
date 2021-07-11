USE [GISData]
GO
/****** Object:  Table [dbo].[Non_Driving_Renter_ID]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Non_Driving_Renter_ID](
	[Contract_Number] [int] NOT NULL,
	[Type] [varchar](20) NULL,
	[Number] [varchar](20) NULL,
	[Expiry] [datetime] NULL,
 CONSTRAINT [PK_Non_Driving_Renter_ID] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Non_Driving_Renter_ID]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract13] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Non_Driving_Renter_ID] CHECK CONSTRAINT [FK_Contract13]
GO
