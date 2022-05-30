SELECT l.owner, l.column_name AS object_name, 'LOB_COLUMN' AS object_type,
          l.table_name, s.bytes/1024/1024 MB,
          s.tablespace_name
    FROM   dba_lobs l, dba_segments s
    WHERE  s.segment_name = l.segment_name
    AND    s.owner = l.owner
    AND    s.segment_type='LOBSEGMENT' and s.owner in ('USER1','USER2','USER3') order by MB desc;
