# php83-apache

Immagine PHP 8.3 + Apache con moduli essenziali (mysqli, imagick, curl, xsl, opcache, rewrite...).

## Utilizzo

```bash
docker pull ghcr.io/redenfire/php83-apache:latest

docker run -p 8080:80 ghcr.io/redenfire/php83-apache:latest
```

Metti i tuoi file PHP in `/var/www/html/` (via volume o COPY nel Dockerfile).
