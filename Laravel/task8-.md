![[laravel-mvc.jpg]]
 
 `To create Laravel project `
*First Way* : for every project
```bash
composer create-project "laravel/laravel:^10.0" example-app
```

*Second Way* : (1) install package  and (2) for every project  
```bash
	// 1 install package
	composer global require laravel/installer
	// another method
	composer create-project laravel/laravel example-app
	
	// 2 for every project  
	laravel new example-app
```

To Run your project use 
```bash
	php artisan serve
```

Laravel 10  Tree
![[treeLaravel.png]]
To You Know laravel version
```bash
	php artisan --version
```


## To make controller in api
```bash
php artisan make:controller Api/SettringController --api
```

## To show data 
```
http://127.0.0.1:8000/api/routeName
http://127.0.0.1:8000/api/settings

// to show in postamn
http://127.0.0.1:8000/api/routeName
http://127.0.0.1:8000/api/settings
```

## To return data in API from controller
```php
public function __invoke(Request $request)
{
	$settings = Settings::findOrFail(1);
	return response()->json($settings);
}
```

## To Controller to display data use `Model Resource`
- **Model Resource (API Resource)** is a layer that controls how your database data is returned as JSON in APIs.
- 🧠 Model = data in database  
- 🎯 Resource = clean JSON output for API/mobile apps

1. create resource
```bash
 php artisan make:resource SettingsResource
```

2. in function `toArray` to control the data would be returned.
```php
public function toArray(Request $request): array
{
	return [
		'id' => $this->id,
		'name' => $this->name,
		'value' => $this->value
	];
}
```

3. Call in controller to call one record
```php
public function __invoke(Request $request)
{
	$settings = Settings::findOrFail(1);
	return new SettingsResource($settings);
}
```

4. call many record use Collections
```php
use App\Http\Resources\PostResource;
use App\Models\Post;

public function index()
{
    return PostResource::collection(Post::all());
}
```
### 🧠 Why This is Powerful
API Resources let you:
- Hide sensitive data (passwords, tokens)
- Format output for mobile apps
- Add computed fields
- Keep controllers clean

------
## API Response Schema
1. make `apiResponse.php` in folder `Helpers`
```php
<?php
namespace App\helpers;
	class ApiResponse {
	public static function response($code = 201, $message = null, $data = null) {
		return response()->json([
			'status' => $code,
			'message' => $message,
			'data' => $data
		]);
	}
}
```

## Enhance API the End point with Response Schema
```php
public function __invoke(Request $request)
{
	$data = Settings::find(1);
	if($data) {
		return ApiResponse::sendResponse(200, "Success", $data);
	}
	return ApiResponse::sendResponse(404, "Not Found");
}
```

## Enhance API the End point in postman
- we make it for another developer 
1. `save example ` in postamn

-  make shortcut form url 
```
http://127.0.0.1:8000/api/settings
```
1. right click on part to make shortcut 
2. select save as variable
3. make name 
4. iden collection
5. to call it
```
{{api-url}}/api/settings
```

## Ways to send query params in postman
`1. Way One`
1.  make query in route
```php
Route::get('cities/{name}' , [Controller::class , 'index']);
```

2. in controller 
```php
public function __invoke(Request $request , $name)
{
	// dd($request);
	$ditricts = Ditricts::where('city_id', $name)->get();
	if (count($ditricts) > 0) {
		return ApiResponse::sendResponse(200, "Ditricts Retrieved Successfully", DitrictsResource::collection($ditricts));
	}
	return ApiResponse::sendResponse(200, "No Ditricts Found", []);
}
```

3. in postman
```
{{api-url}}api/ditricts/name
{{api-url}}api/ditricts?city_id=city2
```

`2. AnotherWay`
1. don't make send query params in route
2. in controller receive the data from request

```php
public function __invoke(Request $request)
{
	// dd($request);
	$ditricts = Ditricts::where('city_id', $request->city_id)->get();
	if (count($ditricts) > 0) {
		return ApiResponse::sendResponse(200, "Ditricts Retrieved Successfully", DitrictsResource::collection($ditricts));
	}
	return ApiResponse::sendResponse(200, "No Ditricts Found", []);
}
```

3. in postman
```
{{api-url}}api/ditricts?city_id=2
```

## How to recall Resource in Another Resource
- make object as OOP
```php
public function toArray(Request $request): array
{
	return
	[
		'id' => $this->id,
		'name' => $this->name,
		'city' => new CitiesResource($this->city),
	];
}
```

----------

## How to store data in DB
1. make Route type post
2. make controller
3. make validation by from request
```php
public function __invoke(StoreMessage $request)
{
	$request->validated();
	$record = Message::create($request->all());
	if($record){
		return ApiResponse::sendResponse(201, "Message Sent Successfully", []);
	}
}
```

- in form request add this
```php
protected function failedValidation(\Illuminate\Contracts\Validation\Validator $validator)
{
	if ($this->is('api/*')) {
		$response = ApiResponse::sendResponse(422, "Validation Error", $validator->errors());
		throw new \Illuminate\Validation\ValidationException($validator, $response);
	}
}
```

4. in postman create request type post
5. identify URL in postman
```
{{api-url}}api/messages
```

6. in header add Accept by `application/json` 
7. to test in postman to send data use `form-data` from `Body`

-------

## Authentication using API (Laravel Sanctum)
1. install laravel sanctum
```bash
composer require laravel/sanctum
```

2. publish
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

3. migrate DB
```bash
php artisan migrate
```

4.  Issuing API Tokens in model user
```php
use Laravel\Sanctum\HasApiTokens;
class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
}
```

5. make route 
```php
Route::controller(AuthController::class)->group(function () {
	Route::post('/register', 'register');
	Route::post('/login', 'login');
	Route::post('/logout', 'logout');
});
```

6. make Controller
```php
<?php
namespace App\Http\Controllers\Api;
use App\helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
	public function register(Request $request)
	{
	// Validation
	$validator = Validator::make($request->all(), [
		'name' => 'required|string|max:255',
		'email' => 'required|email|unique:users,email',
		'password' => 'required|min:6'
	]);
	
	// Check validation
	if ($validator->fails()) {
		return ApiResponse::sendResponse(422, "Validation Error", $validator->errors());
	}
	  
	// Create user
	$user = User::create([
		'name' => $request->name,
		'email' => $request->email,
		'password' => Hash::make($request->password),
	]);

	// Return response
		return ApiResponse::sendResponse(201, "User Created Successfully", [
		'user' => $user,
		'token' => $user->createToken('auth_token')->plainTextToken,
		]);
		}
	}
	
	
	public function login(Request $request)
	{
		// Validation
		$validator = Validator::make($request->all(), [
			'email' => 'required|email',
			'password' => 'required',
		]);
	
		// Check validation
		if ($validator->fails()) {
			return ApiResponse::sendResponse(422, "Validation Error", $validator->errors());
		}

		// Check email
		$user = User::where('email', $request->email)->first();
	
		// Check password
		if (!$user || !Hash::check($request->password, $user->password)) {
			return ApiResponse::sendResponse(401, "Unauthorized");
		}
		
		// Return response
		return ApiResponse::sendResponse(200, "Login Successfully", [
			'user' => $user,
			'token' => $user->createToken('auth_token')->plainTextToken,
		]);
		
	public function logout(Request $request)
	{
		$request->user()->tokens()->delete();
		return ApiResponse::sendResponse(200, "Logout Successfully");	
	}
}
```

- to make test for logout 
```postman
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json
Accept: application/json
```

## `We need token to insert any data in Any Table`



