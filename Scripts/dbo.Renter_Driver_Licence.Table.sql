USE [GISData]
GO
/****** Object:  Table [dbo].[Renter_Driver_Licence]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Renter_Driver_Licence](
	[Contract_Number] [int] NOT NULL,
	[Licence_Number] [varchar](25) NOT NULL,
	[Jurisdiction] [varchar](20) NULL,
	[Expiry] [datetime] NULL,
	[Class] [char](1) NULL,
 CONSTRAINT [PK_Renter_Driver_Licence] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Renter_Driver_Licence]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract12] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Renter_Driver_Licence] CHECK CONSTRAINT [FK_Contract12]
GO
