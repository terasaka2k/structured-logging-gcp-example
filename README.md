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
curl https://XXX.run.app/trace

open "https://console.cloud.google.com/logs/query;query=resource.type%3D%22cloud_run_revision%22%0Aresource.labels.service_name%3D%22structured-logging-gcp-example%22?project=$GOOGLE_CLOUD_PROJECT"
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
