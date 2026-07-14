# Laravel

## The N+1 query problem in Laravel

#### The N+1 Query Problem happens when Laravel executes:

- 1 query to get a list of records.
- Then N additional queries to load related data for each record.

  `Example` :
  - you has post and user model are related with each other

```php
class Post extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

// N  + 1 Query

// one query
$posts = Post::all();

// N Query
foreach ($posts as $post) {
    echo $post->user->name;
}
```

##### Solution By Using Eager Loading

```php
$posts = Post::with('user')->get();

foreach ($posts as $post) {
    echo $post->user->name;
}
```

### Prevent Lazy Loading (Laravel)

- In development, you can make Laravel throw an exception when lazy loading occurs:
- add it in `app service provider`

---

## Attaching, syncing, detaching related records in eloquent

- In Laravel Eloquent, attach(), detach(), and sync() are methods used to manage many-to-many relationships (belongsToMany).

`Eaxmple`: If You have users, roles table

- A user can have many roles, and a role can belong to many users.

### Define the relationship

```php
class User extends Model
{
    public function roles()
    {
        return $this->belongsToMany(Role::class);
    }
}

class Role extends Model
{
    public function users()
    {
        return $this->belongsToMany(User::class);
    }
}

```

#### 1. attach()

- Adds a new relationship without removing existing ones.

```php
$user = User::find(1);

$user->roles()->attach(2);
```

### 2. detach()

- Removes relationships.

```php
$user = User::find(1);
$user->roles()->detach(2);
```

### 3. sync()

- Makes the relationship match exactly the given IDs.

Laravel:

- Adds missing records.
- Removes records not in the list.

```php
$user->roles()->sync([2,4]);
```

### When to Use Each Method

`attach():` Add one or more related records while keeping all existing relationships.
`detach():` Remove one, several, or all relationships.
`sync():` Replace the current relationships with an exact set of IDs (common when processing form submissions with checkboxes).

---

## What is Livewire?

- Livewire is a full-stack framework for Laravel that lets you build dynamic, interactive web interfaces using PHP instead of writing most of the frontend JavaScript.

- It allows you to create components that automatically update the page without a full page refresh, using Laravel on the server behind the scenes.