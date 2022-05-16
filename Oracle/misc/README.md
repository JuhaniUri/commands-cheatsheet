# General & Daily tasks

## Backup settings
### UTL_FILE examples tested in 10G

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('ORALOAD', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('DOCUMENT_LOCATION', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```

```
declare
  f utl_file.file_type;
begin
  f := utl_file.fopen('BATCH_FILES', 'juhani_test.txt', 'w');
  utl_file.put_line(f, 'line one: some text');
  utl_file.put_line(f, 'line two: more text');
  utl_file.fclose(f);
end;
/
```



```
begin
  Utl_File.Fcopy (
       src_location  => 'ORALOAD',
       src_filename  => 'test.txt',
       dest_location => 'BATCH_FILES',
       dest_filename => 'test.txt' );
end;
/
```

### Test env delete archivelog
```
echo "connect target;delete noprompt archivelog until time 'sysdate - 1';"|rman
```