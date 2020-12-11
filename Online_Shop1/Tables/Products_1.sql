CREATE TABLE [Master].[Products] (
    [ID]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NULL,
    [Type] VARCHAR (30) NULL,
    CONSTRAINT [PK_Master_Products] PRIMARY KEY CLUSTERED ([ID] ASC)
);

