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

### 1 HAproxy + 2 Tomcat + Active/standby PostgreSQL
```mermaid
flowchart TB
    user[User] --> haproxy1[HAProxy 1]
    user[User] --> haproxy2[HAProxy 2]
    haproxy1 --> tomcat1[Tomcat Server 1]
    haproxy2 --> tomcat2[Tomcat Server 2]
    tomcat1 --> postgresql_primary[PostgreSQL Primary]
    tomcat2 --> postgresql_primary
    postgresql_primary -.-> postgresql_standby[PostgreSQL Standby]
    postgresql_standby -.->|Replication| postgresql_primary
```

### 1 HAproxy + Tomcat Cluster + Active/standby PostgreSQL

```mermaid
flowchart TB
    HAProxy -->|forwards requests| TomcatCluster
    subgraph TomcatCluster [Tomcat Cluster]
        Tomcat1
        Tomcat2
        Tomcat3
    end
    Tomcat1 -->|read/write| PostgreSQLCluster
    Tomcat2 -->|read/write| PostgreSQLCluster
    Tomcat3 -->|read/write| PostgreSQLCluster
    subgraph PostgreSQLCluster [PostgreSQL Cluster]
        PostgreSQLMaster
        PostgreSQLReplica1
        PostgreSQLReplica2
    end
    PostgreSQLMaster -->|replicates to| PostgreSQLReplica1
    PostgreSQLMaster -->|replicates to| PostgreSQLReplica2
```
