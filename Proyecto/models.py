05-38072@leto:~/fase6/usb]$ python manage.py inspectdb
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#     * Rearrange models' order
#     * Make sure each model has one field with primary_key=True
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.

from django.db import models

class UsrServiciados(models.Model):
Traceback (most recent call last):
  File "manage.py", line 11, in <module>
    execute_manager(settings)
  File "/usr/lib/pymodules/python2.6/django/core/management/__init__.py", line 438, in execute_manager
    utility.execute()
  File "/usr/lib/pymodules/python2.6/django/core/management/__init__.py", line 379, in execute
    self.fetch_command(subcommand).run_from_argv(self.argv)
  File "/usr/lib/pymodules/python2.6/django/core/management/base.py", line 191, in run_from_argv
    self.execute(*args, **options.__dict__)
  File "/usr/lib/pymodules/python2.6/django/core/management/base.py", line 220, in execute
    output = self.handle(*args, **options)
  File "/usr/lib/pymodules/python2.6/django/core/management/base.py", line 351, in handle
    return self.handle_noargs(**options)
  File "/usr/lib/pymodules/python2.6/django/core/management/commands/inspectdb.py", line 22, in handle_noargs
    for line in self.handle_inspection(options):
  File "/usr/lib/pymodules/python2.6/django/core/management/commands/inspectdb.py", line 54, in handle_inspection
    for i, row in enumerate(connection.introspection.get_table_description(cursor, table_name)):
  File "/usr/lib/pymodules/python2.6/django/db/backends/oracle/introspection.py", line 47, in get_table_description
    cursor.execute("SELECT * FROM %s WHERE ROWNUM < 2" % self.connection.ops.quote_name(table_name))
  File "/usr/lib/pymodules/python2.6/django/db/backends/util.py", line 15, in execute
    return self.cursor.execute(sql, params)
  File "/usr/lib/pymodules/python2.6/django/db/backends/oracle/base.py", line 507, in execute
    return self.cursor.execute(query, self._param_generator(params))
django.db.utils.DatabaseError: ORA-22812: cannot reference nested table column's storage table