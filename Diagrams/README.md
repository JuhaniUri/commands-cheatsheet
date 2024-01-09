# Diagrams

## Some examples with Mermaid

### 1 HAproxy + 2 Tomcat + Active/standby PostgreSQL
```mermaid
flowchart TB
    user[User] --> haproxy[HAProxy]
    haproxy --> tomcat1[Tomcat Server 1]
    haproxy --> tomcat2[Tomcat Server 2]
    tomcat1 --> postgresql_primary[PostgreSQL Primary]
    tomcat2 --> postgresql_primary
    postgresql_primary -.-> postgresql_standby[PostgreSQL Standby]
    postgresql_standby -.->|Replication| postgresql_primary
```

