USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Vehicle_Lease_History]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Vehicle_Lease_History](
	[Unit_Number] [int] NOT NULL,
	[Lessee_id] [smallint] NOT NULL,
	[Initial_Cost] [decimal](9, 2) NULL,
	[Interest_Rate] [decimal](9, 2) NULL,
	[Principle_Rate] [decimal](9, 2) NULL,
	[Lease_Start_Date] [datetime] NOT NULL,
	[Lease_End_Date] [datetime] NULL,
	[Private_Lease] [bit] NULL,
	[Last_Update_On] [datetime] NULL,
 CONSTRAINT [PK_FA_Vehicle_Lease_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Lessee_id] ASC,
	[Lease_Start_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Vehicle_Lease_History]  WITH CHECK ADD  CONSTRAINT [FK_FA_Vehicle_Lease_FA_Lessee] FOREIGN KEY([Lessee_id])
REFERENCES [dbo].[FA_Lessee] ([Lessee_ID])
GO
ALTER TABLE [dbo].[FA_Vehicle_Lease_History] CHECK CONSTRAINT [FK_FA_Vehicle_Lease_FA_Lessee]
GO
ALTER TABLE [dbo].[FA_Vehicle_Lease_History]  WITH NOCHECK ADD  CONSTRAINT [FK_FA_Vehicle_Lease_Vehicle] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[FA_Vehicle_Lease_History] CHECK CONSTRAINT [FK_FA_Vehicle_Lease_Vehicle]
GO
