select concat(' alter table ', CONSTRAINT_SCHEMA, '.', TABLE_NAME, ' add constraint ', CONSTRAINT_NAME, ' foreign key (', COLUMN_NAME,') references ' , REFERENCED_TABLE_SCHEMA, '.', REFERENCED_TABLE_NAME, ' (', REFERENCED_COLUMN_NAME, ');') from KEY_COLUMN_USAGE where REFERENCED_COLUMN_NAME is not null