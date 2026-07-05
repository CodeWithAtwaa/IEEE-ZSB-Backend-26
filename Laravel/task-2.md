# Laravel

## What is Gate ?

- Gate is a simple authorization mechanism used to determine whether a user is allowed to perform a specific action. It is best for simple permissions that don't require a full policy class.

#### When to use Gates

Use Gates when the authorization logic is:

- Simple
- Not tied to a specific model
- Global permissions

###### Step 1: define Gate

- define gate in app service provider in boot method

```php
use Illuminate\Support\Facades\Gate;

Gate::define('access-admin', function ($user) {
    return $user->is_admin;
});
```

###### step 2: Check the gate

- in controller

```php
if (Gate::allows('access-admin')) {
    // User is allowed
}

// or
Gate::authorize('access-admin');
```

#### In Blade Templates

```php
@can('access-admin')
    <a href="/admin">Admin Panel</a>
@endcan

//
@cannot('access-admin')
    You are not an admin.
@endcannot
```

```
| Gate                        | Policy                             |
| --------------------------- | ---------------------------------- |
| Simple permissions          | Model-specific permissions         |
| Global authorization        | Authorization for a specific model |
| Few authorization rules     | Many CRUD rules                    |
| Example: Access admin panel | Example: Update a specific post    |
```

#### example

Email Must Be Verified

```php
//  in app service provicer
Gate::define('purchase-product', function (User $user) {
    return $user->hasVerifiedEmail();

//  in controller
});
if (Gate::allows('purchase-product')) {
    // Purchase
}
```

##### Gates Method

```
|----------|----------|
|Allows    |Return T/F|
|Denies    |Opposite  |
|check     |Checks multiple abilities. REturn T|
|authorize |Return T/F|

```

#### Gate::before()

Runs before every gate.

Useful for Super Admins.

```php
Gate::before(function (User $user, string $ability) {
    if ($user->is_super_admin) {
return true;
}
});
```

#### Gate::after()

Runs after authorization.

Useful for logging.

```php
Gate::after(function (
User $user,
string $ability,
bool $result
) {
logger()->info([
'user' => $user->id,
'ability' => $ability,
'allowed' => $result,
]);
});
```

#### Behind the scene

- Whene you call

```php
Gate::authorize('edit-post', $post);
```

- Laravel roughly performs these steps:

```
Controller
      │
      ▼
Gate::authorize()
      │
      ▼
Find ability named "edit-post"
      │
      ▼
Retrieve authenticated user
      │
      ▼
Execute callback:
function(User $user, Post $post)
      │
      ▼
Returns true / false (or a Response)
      │
      ▼
Allowed → Continue request
Denied → Throw AuthorizationException
      │
      ▼
HTTP 403
```

---

## Policy

- A Policy in Laravel is a class that organizes authorization logic for a specific model

- Gate = "Can the user perform this general action?"
- Policy = "Can the user perform this action on this specific model?"

#### When to use Policies

Use a Policy when authorization depends on a model instance.

Examples:

✅ Can the user edit this post?
✅ Can the user delete this comment?
✅ Can the user view this order?
✅ Can the user publish this article?

###### Example

Suppose you have:

```
users
------
id
name

posts
------
id
title
body
user_id
```

Only the post owner should be able to edit or delete the post.

### Step 1: create policey

```php
php artisan make:policy --model=Post
```

### Step 2: Write Authorization Methods

```php
namespace App\Policies;

use App\Models\Post;
use App\Models\User;

class PostPolicy
{
    public function update(User $user, Post $post)
    {
        return $user->id === $post->user_id;
    }

    public function delete(User $user, Post $post)
    {
        return $user->id === $post->user_id;
    }
}
```

### Step 3: Register the Policy

- in the bootstrap

### Step 4: Use the Policy

In a controller:

```php
public function edit(Post $post)
{
    $this->authorize('update', $post);

    return view('posts.edit', compact('post'));
}
```

- You can make policy by Using Gate

Policies are also checked through the Gate facade:

````php
if (Gate::allows('update', $post)) {
    //
}```

or

```php
Gate::authorize('update', $post);
````


### When to Use Which

Use Gate for:

Access Admin Dashboard
Export Reports
Manage Users
View Analytics

Use Policy for:

Edit Post
Delete Comment
Update Product
View Order
Cancel Booking


---------


## use UTC in time Not timestamp 
- Make test in your time 

-------


