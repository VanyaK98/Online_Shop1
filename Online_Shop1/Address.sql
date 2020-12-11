CREATE TABLE [Master].[Address] (
    [Id]     INT           IDENTITY (1, 1) NOT NULL,
    [City]   VARCHAR (50)  NULL,
    [Street] VARCHAR (100) NULL,
    CONSTRAINT [PK_Master_Address] PRIMARY KEY CLUSTERED ([Id] ASC)
);

