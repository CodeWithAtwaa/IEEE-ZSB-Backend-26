
## 1. Understanding HTTP

HTTP (HyperText Transfer Protocol) is the request/response protocol that the web (and Laravel APIs) run on. Here's what I took away from studying it:

- **It's stateless.** Every request is independent — the server doesn't remember previous requests unless we add something extra like a session, cookie, or a token (e.g. Sanctum/JWT in Laravel). That's exactly why authentication in APIs relies on tokens sent with every request instead of the server "remembering" who's logged in.
- **Request structure**: a request has a method, a URL/path, headers, and (optionally) a body. The methods matter a lot for REST design:
  - `GET` – read data, no body, safe & idempotent.
  - `POST` – create a new resource, has a body.
  - `PUT` – replace a resource entirely.
  - `PATCH` – update part of a resource.
  - `DELETE` – remove a resource.
- **Response structure**: status line (status code), headers, and body. Status codes are grouped by the first digit:
  - `2xx` success (200 OK, 201 Created, 204 No Content)
  - `3xx` redirection (301 Moved Permanently, 304 Not Modified)
  - `4xx` client error (400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 422 Unprocessable Entity — this one shows up a lot in Laravel validation errors)
  - `5xx` server error (500 Internal Server Error)
- **Headers** carry metadata about the request/response: `Content-Type` (tells the receiver whether the body is JSON, HTML, form data...), `Authorization` (carries the Bearer token), `Accept`, `Cache-Control`, etc.
- Connecting this to Laravel: when I build an API, every controller method is basically "receive an HTTP request → do something → return an HTTP response with the right status code and JSON body." Understanding HTTP properly is what makes it obvious *why* Laravel has things like `Request` objects, `Response::json()`, and middleware that inspects headers.

## 2. Serialization & Deserialization

This is about converting data between two forms: the in-memory representation a program uses (objects, arrays, model instances) and a format that can be transmitted or stored (usually JSON, sometimes XML).

- **Serialization** = turning an object into a transferable format. In Laravel, when a controller returns an Eloquent model or collection, Laravel automatically serializes it into JSON before sending it as the HTTP response body.
- **Deserialization** = the reverse — taking raw JSON from an incoming request body and turning it back into usable PHP data (arrays/objects) so the app can work with it. Laravel does this automatically too, via the `Request` object (`$request->input('field')` or `$request->all()`).
- Why it matters: the frontend/mobile client and the backend server almost never share the same programming language or memory model, so JSON acts as the universal middle format both sides agree on.
- Things to be careful about:
  - Not every property of a model should be serialized (e.g. `password`, `remember_token`). Laravel handles this with the `$hidden` array on models, or with **API Resources** (`JsonResource`) to control exactly what shape the JSON output takes.
  - Data types can get lost/changed in translation (e.g. a PHP `Carbon` date object becomes a plain string once serialized to JSON, and has to be re-parsed on the way back).
  - Nested relationships need to be explicitly loaded/serialized (eager loading with `with()`), otherwise you get either missing data or the N+1 query problem.

## 3. Caching

Caching means storing a copy of data (or a computed result) somewhere fast to access, so future requests don't have to redo expensive work (a slow DB query, a heavy computation, an external API call).

- **Why**: databases and external services are slow relative to memory. If the same data is requested repeatedly and doesn't change often, recomputing/re-fetching it every time wastes time and resources.
- **How it fits in Laravel**: Laravel has a unified `Cache` facade that can sit on top of different drivers — file, database, Redis, Memcached, array (for testing). Typical usage: `Cache::remember('key', $seconds, fn () => expensiveQuery())` — it checks if `key` exists in the cache; if yes, returns it instantly; if no, it runs the closure, stores the result, and returns it.
- **Cache invalidation** is the hard part — deciding when cached data becomes stale and needs to be refreshed or deleted. Strategies I learned about:
  - **TTL (Time To Live)** – just expire the cache after N seconds/minutes regardless of anything else. Simple but can serve stale data.
  - **Manual invalidation** – explicitly clear/update the cache key whenever the underlying data changes (e.g. clear a "top products" cache whenever a product is updated).
  - **Cache tags** – group related cache entries so they can all be flushed together.
- There's always a trade-off between performance (serving cached/possibly-stale data fast) and consistency (always serving fresh data but slower). This is one of those classic "there are only two hard problems in computer science: cache invalidation and naming things" situations.

## 4. UML Class Diagrams

UML class diagrams are a way to visually document the structure of a system's classes before or while coding it — very useful for planning a Laravel app's models and relationships.

- A class box has 3 sections: **class name**, **attributes** (with visibility: `+` public, `-` private, `#` protected), and **methods**.
- **Relationships** between classes are the part that actually needs practice to read correctly:
  - **Association** — a general "uses/has" relationship, shown as a plain line.
  - **Aggregation** (hollow diamond) — a "has-a" relationship where the parts can exist independently of the whole (e.g. a `Department` has `Employees`, but employees can exist without that department).
  - **Composition** (filled diamond) — a stronger "has-a" where the part's lifecycle depends on the whole (e.g. an `Order` and its `OrderItems` — if the order is deleted, the items don't make sense on their own).
  - **Inheritance** (hollow triangle arrow) — "is-a" relationship, used for class extension.
  - **Multiplicity** (like `1`, `0..1`, `*`, `1..*`) written near the ends of a line tells you how many instances relate to each other — this maps almost directly onto Eloquent relationships in Laravel: `1-to-1`, `1-to-many`, `many-to-many`.
- Practical value for me: sketching a class diagram before writing migrations/models makes it much easier to catch a wrong relationship early (e.g. realizing something should be `belongsToMany` instead of `hasMany`) instead of discovering it after writing a bunch of code.

## 5. Observer Design Pattern

The Observer pattern defines a one-to-many dependency between objects: when one object (the *subject*) changes state, all its dependents (*observers*) are automatically notified and updated, without the subject needing to know the details of what each observer does.

- **Core idea**: decouple the thing that changes from the things that need to react to the change. The subject just says "something happened," and any number of observers can be listening.
- **Real world analogy**: a YouTube channel (subject) and its subscribers (observers) — the channel doesn't know or care who's subscribed or what they'll do with a new video notification; it just broadcasts "new video published."
- **How Laravel implements this concept**: Laravel's **Model Observers** are a direct application of this pattern. Instead of manually writing "when a model is created/updated/deleted, also do X" inside the controller every time, you register an Observer class (`php artisan make:observer UserObserver --model=User`) with methods like `created()`, `updated()`, `deleted()`. Laravel automatically calls the right method whenever that model event fires — the model doesn't need to know what the observer does, it just fires the event.
- Laravel's broader **event/listener system** (`Event::dispatch()` + Listeners) is the same pattern at an even more general level — not tied to Eloquent models specifically.
- Why this matters practically: it keeps side effects (sending a welcome email when a user registers, clearing a cache when a post is updated, logging an action) out of controllers and models, making the codebase cleaner and each piece independently testable.

## 6. Real World System Design (Optional)

I watched this as a bonus to connect the previous topics together. The main things I picked up:

- Designing a real system means combining all of the above: HTTP defines how clients and servers talk, caching decides what's fast-tracked, serialization decides the data contract between services, and design patterns like Observer keep the codebase maintainable as it grows.
- A common theme in system design discussions is **scaling reads vs writes** differently — e.g. adding caching layers or read replicas for read-heavy systems, while write-heavy systems focus more on queues and background jobs.
- Load balancers, horizontal scaling (more servers) vs vertical scaling (bigger servers), and asynchronous processing (queues) came up as recurring building blocks once a system needs to handle more traffic than a single server can.

## Resources I used
- Laravel official documentation (Eloquent, Caching, Events & Listeners, API Resources)
- MDN Web Docs — HTTP overview and status codes reference
- Refactoring.Guru — Observer design pattern explanation and examples
- General UML class diagram references for notation (relationship arrows, multiplicity)

## Notes on LLM usage
I used an LLM (Claude) to help organize and write up these notes clearly after going through the material, and to double check my understanding of how the Observer pattern maps to Laravel's Model Observers and Events/Listeners system.
