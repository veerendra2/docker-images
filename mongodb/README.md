# MongoDB

> See [Install MongoDB Community Edition](https://www.mongodb.com/docs/manual/administration/install-community/?operating-system=linux&linux-distribution=ubuntu&linux-package=default&search-linux=without-search-linux) for installation guide

A minimal MongoDB Docker image built for homelab/homeserver use. Not intended for production environments.

- Version: `8.2.0`
- Image size: `~330MB`
- Tags: `latest` only
- Contains only `mongod` (no `mongosh`, `mongos` or other MongoDB binaries)

## Usage

### Environment Variables

> If env vars are unset, [mongo-init](./mongo-init/main.go) creates default credentials: `admin` / `changeme!`.

- `MONGO_INITDB_ROOT_USERNAME` - Initial root user
- `MONGO_INITDB_ROOT_PASSWORD` - Initial root password
- `MONGO_INITDB_ROOT_USERNAME_FILE` - File containing username
- `MONGO_INITDB_ROOT_PASSWORD_FILE` - File containing password

### Docker Compose Example

```yaml
services:
  mongo:
    image: veerendra2/mongodb
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: myroot
      MONGO_INITDB_ROOT_PASSWORD: example

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://myroot:example@mongo:27017/
      ME_CONFIG_BASICAUTH_ENABLED: true
```

```bash
docker compose -f compose.yml up
```

- Go to http://localhost:8081
  - Username: `myroot`
  - Passoword: `example`
