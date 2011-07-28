Flatten migrations
===================

A gem that adds db:flatten_migrattions to rake tasks in your rails project.

Requirements
------------

You have to ensure that your **schema format is set to :ruby** in configuration of
your project.  
So in your *project*/config/environments/*.rb you should have a line:  
> config.active_record.schema_format = :ruby

How does it work
----------------

What the task does is:

  1. run pending migrations (rake db:migrate)
  2. wipe out <PROJECT>/db/migrate direcotry
  3. generate initial migration from existing database schema file
  4. run the new migration

The new migration will clear schema_migrations table so it won't mess up
with versions. It is also irreversible.