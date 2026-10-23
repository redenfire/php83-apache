# php83-apache

Immagine **PHP 8.3.36 + Apache** basata su `php:8.3.36-apache`.

## Cosa include

- **Apache** con `mod_rewrite` attivo
- **PHP 8.3.36** con le estensioni predefinite dell'immagine ufficiale (`curl`, `mbstring`, `dom`, `fileinfo`, `ctype`, `filter`, `opcache`, ...)
- **Estensioni PHP** aggiunte: `calendar`, `exif`, `ftp`, `gettext`, `mysqli`, `pdo_mysql`, `shmop`, `sockets`, `sysvmsg`, `sysvsem`, `sysvshm`, `xsl`, `imagick`
- **GD** (con JPEG/FreeType/PNG) solo nelle varianti con GD (`WITH_GD=1`, tag `*-gd`)

## Build manuale dell'immagine

Dalla root del repository, variante normale (senza GD):

```bash
docker build -t php83-apache .
```

Variante con GD (JPEG, FreeType, PNG):

```bash
docker build --build-arg WITH_GD=1 -t php83-apache-gd .
```

Se usi un'architettura diversa da quella host (es. ARM su Intel):

```bash
docker build --platform linux/amd64 -t php83-apache .
```

> L'immagine base `php:8.3.36-apache` viene scaricata automaticamente dal registry se non è già presente localmente.

## Usare l'immagine prebuild da GitHub

L'immagine viene compilata automaticamente su GitHub Actions ad ogni push su `main` o tag `v*` e ogni notte, e pubblicata su GitHub Container Registry in due varianti: **normale** (senza GD) e **con GD** (JPEG/FreeType/PNG).

| Tag                        | Architettura | Variante |
|----------------------------|--------------|----------|
| `ghcr.io/redenfire/php83-apache:latest`    | **amd64** (x86_64) | normale |
| `ghcr.io/redenfire/php83-apache:arm`       | **arm64** | normale |
| `ghcr.io/redenfire/php83-apache:latest-gd` | **amd64** (x86_64) | con GD |
| `ghcr.io/redenfire/php83-apache:arm-gd`    | **arm64** | con GD |

Pull per architettura amd64:

```bash
docker pull ghcr.io/redenfire/php83-apache:latest       # normale
docker pull ghcr.io/redenfire/php83-apache:latest-gd    # con GD
```

Pull per architettura arm64 (es. Raspberry Pi, Apple Silicon):

```bash
docker pull ghcr.io/redenfire/php83-apache:arm          # normale
docker pull ghcr.io/redenfire/php83-apache:arm-gd       # con GD
```

Per una versione con tag specifico (es. `v1`):

```bash
docker pull ghcr.io/redenfire/php83-apache:v1            # amd64 normale
docker pull ghcr.io/redenfire/php83-apache:arm-v1        # arm64 normale
docker pull ghcr.io/redenfire/php83-apache:gd-v1         # amd64 con GD
docker pull ghcr.io/redenfire/php83-apache:arm-gd-v1     # arm64 con GD
```

> Se il package non è pubblico, devi prima fare login con `docker login ghcr.io -u NOME_UTENTE --password-stdin`.
> I tag `latest` e `arm` sono **senza** GD; per GD usa `latest-gd` e `arm-gd`.

## Esecuzione

Dopo la build avvia il container:

```bash
docker run -d --name php83-apache -p 8080:80 php83-apache
```

Il container espone la porta **80**. Con questo esempio accedi su `http://localhost:8080`.

Il document root è `/var/www/html`. Per montare il tuo codice dal host:

```bash
docker run -d --name php83-apache -p 8080:80 -v /path/del/tuo/codice:/var/www/html php83-apache
```

## Verifica

Senza un file `index.php`/`index.html` nel document root la home restituisce `403`. Per testare che PHP funzioni:

```bash
docker exec php83-apache sh -c 'echo "<?php echo \"ok \" . PHP_VERSION; ?>" > /var/www/html/index.php'
curl http://localhost:8080/
```

## Arresto e pulizia

```bash
docker stop php83-apache
docker rm php83-apache
```

Per rimuovere anche l'immagine locale:

```bash
docker rmi php83-apache
```
