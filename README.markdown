Flatten migrations
===================

A gem that adds db:flatten_migrattions to rake tasks in your rails project.

Requirements
------------

You have to ensure that your **schema format is set to :ruby** in configuration of
your project.  
So in your *project*/config/environments/*.rb you should have a line:  

```
config.active_record.schema_format = :ruby
```

How does it work
----------------

The task steps are as follows:

  1. run pending migrations (rake db:migrate)
  2. wipe out *project*/db/migrate direcotry
  3. generate initial migration from existing database schema file
     initial migration is assumed to be the one which was last executed
  4. create auxiliary migration which adjusts the schema_migrations table
  5. run the new migration

**Both new migrations (*initial* and *auxiliary*) are also irreversible.**

Your database is safe and it should not erase any data except the schema_migrations table. 