# etcd Storage Bloat - Compaction and Defragmentation Recovery

Your platform team has noticed that API write requests are beginning to fail intermittently. Monitoring shows the etcd database is approaching its configured size limit. You need to perform compaction to remove old revisions, defragment the etcd data files to reclaim disk space, and clear the storage alarm before the API server becomes fully read-only.

> **Day 174 of KubeSkills Daily** — Fail Fast, Learn Faster
