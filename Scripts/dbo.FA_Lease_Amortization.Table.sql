USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Lease_Amortization]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Lease_Amortization](
	[Unit_number] [int] NOT NULL,
	[Lessee_ID] [smallint] NOT NULL,
	[AMO_Month] [datetime] NOT NULL,
	[Principle] [decimal](9, 2) NULL,
	[Interest] [decimal](9, 2) NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_Lease_Amortization] PRIMARY KEY CLUSTERED 
(
	[Unit_number] ASC,
	[Lessee_ID] ASC,
	[AMO_Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Lease_Amortization]  WITH NOCHECK ADD  CONSTRAINT [FK_FA_Lease_Amortization_Vehicle] FOREIGN KEY([Unit_number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[FA_Lease_Amortization] CHECK CONSTRAINT [FK_FA_Lease_Amortization_Vehicle]
GO
