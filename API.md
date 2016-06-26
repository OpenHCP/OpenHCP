## API v0

All API calls must be prefixed with API version, for example: "/v0/client/get"

## /client/add

Adds a client.

# parameters

- name (required)
 - distinctive name of the client
 - "/^[a-z]+[a-z0-9]+[a-z]+$/"
 - will be group name and base to some of the login names
 - client doesn't have to have unix group id (for example client only with domains)
- active (optional)
 - by default client is active

# parameters JSON

[{"name":string}]

# SQL

INSERT INTO client SET name=:name

## /client/get

Gets client simple info.

# parameters

- id (optional / required if no name)
- name (optional / required if no id)

# parameters JSON

- [{"id":int}]
- [{"name":string}]

# SQL

SELECT * FROM client WHERE id=:id OR name=:name

# output

JSON array with all data from `client` table

# output JSON

[{"id":int,"name":string,"gid":int,"active":int}]

## /client/gid/assign

Automatically assign new gid to client.

# parameters

- id (optional / required if no name)
 - id of the client in the `client` table
- name (optional / required if no id)
 - name of the client in the `client` table

# parameters JSON

- [{"id":int}]
- [{"name":string}]

# SQL

INSERT INTO client SET gid=( SELECT MAX(gid) + 1 FROM client) WHERE id=:id OR name=:name

# output

Integer with GID

# output JSON

[{"gid":int}]

## /mail/domain/add

## /mail/user/add

