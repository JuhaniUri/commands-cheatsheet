SELECT
    *
FROM
    (
        SELECT
            owner,
            segment_type,
            segment_name,
            bytes / 1024 / 1024 / 1024 "SIZE (GB)"
        FROM
            dba_segments
        WHERE
            segment_name NOT LIKE 'BIN%'
        ORDER BY
            4 DESC
    )
WHERE
    ROWNUM <= 10;
