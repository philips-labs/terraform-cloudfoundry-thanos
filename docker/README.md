# Alpine Dockerfile for multi-processor runs
## Build Thanos Docker image
You can build Thanos with paas-prometheus-exporter based on https://github.com/alphagov/paas-prometheus-exporter

Run 

```
git clone https://github.com/alphagov/paas-prometheus-exporter.git
docker build -t thanos -f Dockerfile_with_exporter
```

and build without paas-prometheus-exporter
```
docker build -t thanos
```

## Change period of uploading Prometheus data into S3
Change these parameters. Values should be equals
```
--storage.tsdb.min-block-duration=30m --storage.tsdb.max-block-duration=30m
```


## Add more exporters to Prometheus

Add new section `job_name` into `scrape_configs` section in `prometheus.yml`.

For Example:
```  
 - job_name: <some_job_name>
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:18080', <_urls_>]
        labels:
          group: '<some_group_name>'
```