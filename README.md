# Setup Guide

[API Docs](#api-docs)

[Testing](#testing)

### Clone the repo:

```
git clone https://github.com/atasker/jurassic-park-api.git
```

### cd into new directory:

```
cd jurassic-park-api
```

### Create database and run migrations:

```
rails db:create db:migrate
```

### Populate the database with some seed data:

```
rails db:seed
```

### Your local environment is now setup to use the API on your localhost.

# API Docs

**Note:** *Make sure to start your local server with* `rails server`

### ENDPOINTS:

#### ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) GET /api/v1/cages

**Curl**

```lang-bash
curl --location --request GET http://localhost:3000/api/v1/cages
```

**Response:**

> Returns all cages.
> Status code: 200

```
[
  {
    "id": 1,
    "maximum_capacity": 5,
    "power_status": "active",
    "dinosaur_count": 3
  },
  {
    "id": 2,
    "maximum_capacity": 5,
    "power_status": "active",
    "dinosaur_count": 5
  },
  {
    "id": 3,
    "maximum_capacity": 5,
    "power_status": "active",
    "dinosaur_count": 2
  }
]
```

---

#### ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) GET /api/v1/cages/:id

**Curl**

```lang-bash
curl --location --request GET http://localhost:3000/api/v1/cages/1
```

**Response:**

> Returns specific cage by id.
> Status code: 200

```
{
  "cage": {
    "id": 1,
    "maximum_capacity": 5,
    "power_status": "active"
  },
  "dinosaurs": [
    {
      "id": 1,
      "name": "steve",
      "species": "stegosaurus",
      "cage_id": 1
    },
    {
      "id": 2,
      "name": "elliott",
      "species": "triceratops",
      "cage_id": 1
    },
    {
      "id": 3,
      "name": "yvan",
      "species": "stegosaurus",
      "cage_id": 1
    }
  ]
}
```

---

#### ![#ffff00](https://via.placeholder.com/15/ffff00/000000?text=+) POST /api/v1/cages

**Curl**

```lang-bash
curl --request POST \
  --url http://localhost:3000/api/v1/cages \
  --header 'Content-Type: application/json' \
  --data '{
	"power_status": 1
}'
```

**Response:**

> Creates a cage.
> 201: Created

```
{
  "id": 4,
  "maximum_capacity": 5,
  "power_status": "active"
}
```

---

#### ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) PUT /api/v1/cages/:id

**Curl**

```lang-bash
curl --request PUT \
  --url http://localhost:3000/api/v1/cages/4 \
  --header 'Content-Type: application/json' \
  --data '{
	"maximum_capacity": 15,
  "power_status": "down"
}'
```

**Response:**

> Updates cage.
> 204: No content

---

#### ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) GET /api/v1/dinosaurs

**Curl**

```lang-bash
curl --location --request GET http://localhost:3000/api/v1/dinosaurs
```

**Response:**

> Returns all dinosaurs.
> Status code: 200

```
[
  {
    "id": 1,
    "name": "steve",
    "species": "stegosaurus",
    "cage_id": 1
  },
  {
    "id": 2,
    "name": "elliott",
    "species": "triceratops",
    "cage_id": 1
  },
  {
    "id": 3,
    "name": "yvan",
    "species": "stegosaurus",
    "cage_id": 1
  }
]
```

---

#### ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) GET /api/v1/dinosaurs/:id

**Curl**

```lang-bash
curl --location --request GET http://localhost:3000/api/v1/dinosaurs/1
```

**Response:**

> Returns specific dinosaur by id.
> Status code: 200

```
{
  "id": 1,
  "name": "steve",
  "species": "stegosaurus",
  "cage_id": 1
}
```

---

#### ![#ffff00](https://via.placeholder.com/15/ffff00/000000?text=+) POST /api/v1/dinosaurs

**Curl**

```lang-bash
curl --request POST \
  --url http://localhost:3000/api/v1/dinosaurs \
  --header 'Content-Type: application/json' \
  --data '{
 "name": "mr rex",
 "species": "tyrannosaurus",
 "cage_id": 2
}'
```

**Response:**

> Creates a dinosaur.
> 201: Created

```
{
  "id": 2,
  "name": "mr rex",
  "species": "tyrannosaurus",
  "cage_id": 1
}
```

---

#### ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) PUT /api/v1/dinosaurs/:id

**Curl**

```lang-bash
curl --request PUT \
  --url http://localhost:3000/api/v1/dinosaurs/1 \
  --header 'Content-Type: application/json' \
  --data '{
	"cage_id": 1
}'
```

**Response:**

> Updates dinosaur.
> 204: No content

# Testing

### All tests can be found in the `/spec/requests` folder.

### To run tests locally:

```
bundle exec rspec
```

![passing tests](https://i.ibb.co/DpSsD4M/Screen-Shot-2021-01-31-at-10-34-23-PM.png)