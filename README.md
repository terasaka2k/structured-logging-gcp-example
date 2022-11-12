# Structured Loggingの簡単な検証


# Dev (GCP)
```bash
GOOGLE_CLOUD_PROJECT=YOUR_GOOGLE_CLOUD_PROJECT

cat <<EOF >.env.dev
GOOGLE_CLOUD_PROJECT=$GOOGLE_CLOUD_PROJECT
EOF
```

```bash
make deploy-dev
```

```bash
make curl-trace-dev

open (Cloud Logging URL)
```

```bash
make destroy-dev
```


# Local
```bash
make init

make run-container-local
```

```bash
make curl-trace-local
```
