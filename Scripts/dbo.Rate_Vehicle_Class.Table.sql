USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Vehicle_Class]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Vehicle_Class](
	[Rate_Vehicle_Class_ID] [int] IDENTITY(1,1) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Per_KM_Charge] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_Rate_Vehicle_Class] PRIMARY KEY CLUSTERED 
(
	[Rate_Vehicle_Class_ID] ASC,
	[Rate_ID] ASC,
	[Effective_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Rate_Vehicle_Class1] UNIQUE NONCLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Vehicle_Class_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Vehicle_Class]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Vehicle_Class_Vehicle_Rate] FOREIGN KEY([Rate_ID], [Effective_Date])
REFERENCES [dbo].[Vehicle_Rate] ([Rate_ID], [Effective_Date])
GO
ALTER TABLE [dbo].[Rate_Vehicle_Class] NOCHECK CONSTRAINT [FK_Rate_Vehicle_Class_Vehicle_Rate]
GO
ALTER TABLE [dbo].[Rate_Vehicle_Class]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class10] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Rate_Vehicle_Class] CHECK CONSTRAINT [FK_Vehicle_Class10]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_Vehicle_Class_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_Vehicle_Class_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2220 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_Vehicle_Class_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Rate_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Effective_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Effective_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2205 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Effective_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Termination_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Termination_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Termination_Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Vehicle_Class_Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Vehicle_Class_Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=1980 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Vehicle_Class_Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Per_KM_Charge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Per_KM_Charge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class', @level2type=N'COLUMN',@level2name=N'Per_KM_Charge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=0 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Rate_Vehicle_Class'
GO
