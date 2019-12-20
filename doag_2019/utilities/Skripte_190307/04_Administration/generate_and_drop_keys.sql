

SELECT 
    CONCAT(' alter table ',
            CONSTRAINT_SCHEMA,
            '.',
            TABLE_NAME,
            ' add constraint ',
            CONSTRAINT_NAME,
            ' foreign key (',
            COLUMN_NAME,
            ') references ',
            REFERENCED_TABLE_SCHEMA,
            '.',
            REFERENCED_TABLE_NAME,
            ' (',
            REFERENCED_COLUMN_NAME,
            ');')
FROM
    information_schema.KEY_COLUMN_USAGE
WHERE
    REFERENCED_COLUMN_NAME IS NOT NULL;
    
    
SELECT 
    CONCAT(' alter table ',
            CONSTRAINT_SCHEMA,
            '.',
            TABLE_NAME,
            ' drop foreign key ',
            CONSTRAINT_NAME,
            ';')
FROM
    information_schema.KEY_COLUMN_USAGE
WHERE
    REFERENCED_COLUMN_NAME IS NOT NULL
