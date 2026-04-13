# etcd Backup Failure - Disaster Recovery Gone Wrong

The operations team believes they have been taking nightly etcd backups but a recent test revealed the backup script was using the wrong certificate paths and producing empty snapshot files. A simulated cluster state has been created and you must take a valid backup, verify it, and walk through the restore process to prove your disaster recovery procedure actually works.

> **Day 134 of KubeSkills Daily** — Fail Fast, Learn Faster
