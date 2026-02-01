# Dice Game API

Two-player dice game API built with **Ruby on Rails (MVC)**, **In-memory store (Redis-like abstraction)** for game state, and **PostgreSQL** for persistence.

## Features
- RESTful Games API
- Game creation endpoint
- In-memory game state using Redis
- Persistent game history in PostgreSQL

## Tech Stack
- Ruby 3.4.5
- Rails 8.0.4
- Redis
- PostgreSQL

## Running Locally
```bash
bundle install
rails db:create db:migrate
rails server
```

By default, the API will run at `http://localhost:3000`

---

## API Endpoints (Planned)

1. **Start a Game**
   `POST /games/start`
   Request: `{ "player1": "p1", "player2": "p2" }`
   Response: `{ "msg": "game started", "game_id": "123" }`

2. **Play Rounds**
   `POST /games/:game_id`
   Request: `{ "p1_roll": 5, "p2_roll": 4 }`
   Response: `{ "round_winner": "p1" }`

3. **Current Game Status**
   `GET /games/:game_id`
   Response: `{ "current_round": 2, "p1_score": 1, "p2_score": 0, "rounds": [...] }`

4. **Past Game History**
   `GET /games/history`
   Response: `{ "games": [ { "game_id": "123", "winner": "p1", "ended_at": "2026-01-20" }, ... ] }`

---

## Services

* **In-memory store (Redis-like abstraction)**: for temporary storage of ongoing game states
* **PostgreSQL**: for persistence of completed games

---

## Testing

Tests will be added in a future iteration.

---