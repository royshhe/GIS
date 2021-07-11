USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Additional_Driver]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Additional_Driver](
	[Contract_Number] [int] NOT NULL,
	[Additional_Driver_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Customer_ID] [int] NULL,
	[Birth_Date] [datetime] NULL,
	[Driver_Licence_Number] [varchar](25) NULL,
	[Driver_Licence_Jurisdiction] [varchar](20) NULL,
	[Driver_Licence_Expiry] [datetime] NULL,
	[Driver_Licence_Class] [char](1) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](20) NULL,
	[City] [varchar](20) NULL,
	[Province_State] [varchar](20) NULL,
	[Country] [varchar](20) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Addition_Type] [varchar](20) NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Termination_Date] [datetime] NULL,
	[No_Charge] [bit] NOT NULL,
 CONSTRAINT [PK_Contract_Additional_Driver] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Additional_Driver_ID] ASC,
	[Effective_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Additional_Driver] ADD  CONSTRAINT [DF_Contract_Additional_Driver_No_Charge]  DEFAULT (0) FOR [No_Charge]
GO
ALTER TABLE [dbo].[Contract_Additional_Driver]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract14] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Additional_Driver] CHECK CONSTRAINT [FK_Contract14]
GO
ALTER TABLE [dbo].[Contract_Additional_Driver]  WITH CHECK ADD  CONSTRAINT [FK_Customer5] FOREIGN KEY([Customer_ID])
REFERENCES [dbo].[Customer] ([Customer_ID])
GO
ALTER TABLE [dbo].[Contract_Additional_Driver] CHECK CONSTRAINT [FK_Customer5]
GO
