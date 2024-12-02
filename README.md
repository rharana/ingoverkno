# Ingoverkno

This tool is a configuration engine for e-governance platforms built around Software Product Lines (SPL) technology and the Decidim framework.

## Setup
```bash
docker-compose up -d
```

## Complete Reset

```bash
docker-compose down -v
rm -rf instances/*
docker-compose up -d
```