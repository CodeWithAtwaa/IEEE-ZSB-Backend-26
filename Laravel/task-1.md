# Laravel

## Blade Templates and how they work

- Built-in template engine.
- is a view file that contains HTML along with blade syntax.
- blade extentsion file `.blade.php`

##### how they work

- `Route => controller => blade template => browser`

###### step1: use make request

```php
Route::get('/about', [AboutController::class, 'index']);
```

###### step2: Controller prepare data

```php
public function index() {
    $title = 'About US';
    reuturn view('about' , compact("title"));
}
```

###### step3: Blade template

```php
<!DOCTYPE html>
<html>
<head>
    <title>{{$title}}</title>
</head>
<body>

<h1>About Us</h1>

</body>
</html>
```

## What is the ORM, and Why is it so useful

- `ORM` => Object-relation Mapper.
- use to manipulate with database withuout write sql queries.

###### Why is it so useful

- ese to read

```php
$users = User::where('age', '>', 20)->get();
```

- Less SQl to remember
- Relationships Are Easy
- Cleaner Code
- Built-in CRUD Operations

## Facade Design Pattern and How Laravel Use it

- The Facade Design Pattern is a structural design pattern that provides a simple interface to a complex system or a group of classes.
- Instead of interacting directly with multiple objects, you use one class (the facade) that hides all the complexity.

```php
class CPU
{
    public function process()
    {
        echo "CPU Processing...\n";
    }
}

class Memory
{
    public function load()
    {
        echo "Memory Loaded...\n";
    }
}

class ComputerFacade
{
    protected $cpu;
    protected $memory;

    public function __construct()
    {
        $this->cpu = new CPU();
        $this->memory = new Memory();
    }

    public function start()
    {
        $this->memory->load();
        $this->cpu->process();
    }
}

$computer = new ComputerFacade();
$computer->start();
```

## Factory Design Pattern

- The Factory Design Pattern is a creational design pattern.
- Instead of creating objects directly with `new`, a factory class is responsible for creating them.

```php
interface Car
{
    public function drive();
}

class BMW implements Car
{
    public function drive()
    {
        echo "Driving BMW";
    }
}

class Audi implements Car
{
    public function drive()
    {
        echo "Driving Audi";
    }
}

class CarFactory
{
    public static function make($type)
    {
        return match ($type) {
            'bmw' => new BMW(),
            'audi' => new Audi(),
            default => throw new Exception("Unknown car type"),
        };
    }
}

$car = CarFactory::make('bmw');
$car->drive();

```

## solid Preinciples

#### Single Responsibitty

- `S` For Single responsibility principle
- A class should have one and only one Reason to change, meaning that a class should only have one job.
- one class = one job.

```php
// Class Attack
<?php
namespace Classes;
class Attack
{
	public function attack(){
	}
}
?>
// Class Defense
<?php
namespace Classes;
class Defense
{
	public function defense(){
	}
}
?>
// Class Match
<?php
namespace Classes;
class GameMatch
{
	private $attck;
	private $defense;
	private $keeper;
	public function __construct(){
		$this->attck = new Attack();
		$this->defense = new Defense();
		$this->keeper = new Keeper();
	}
	public function start(){
		echo "Start Play";
	}
}
?>
```

#### Open/Close

- Objects or Entities Should be open for extension, but closed for modification.
- You should be able to add new behavior **without changing existing code**.

```php
<?php
	interface Discount {
		public function getDiscount() : int;
	}

	class Regular implements Discount
	{
		public function getDiscount(): int
		{
		return 10;
		}
	}

	class VIP implements Discount
	{
		public function getDiscount(): int
		{
			return 20;
		}
	}



$regluar = new Regular();
echo $regluar->getDiscount() ;

$vip = new VIP();
echo $vip->getDiscount() ;
?>

```

#### Liskov Substitution principle

- Let "A" be a parent class and "B" is the child class From A. Then let "C" use "B" if we change "B" with "A" in "C" class The implementation in "C" should not Change.
- Objects of a superclass should be replaceable with objects of its subclasses without breaking the program.

- Child must work anywhere parent is expected.
- الاستبدال هو عمليه استخدام نفس حاله الكائن بدون تغير السلوك.

```php
<?php

interface Shape {
    public function getArea(): int;
}

class Rectangle implements Shape {
    protected int $width;
    protected int $height;

    public function __construct(int $width, int $height) {
        $this->width = $width;
        $this->height = $height;
    }

    public function getArea(): int {
        return $this->width * $this->height;
    }
}

class Square implements Shape {
    protected int $side;

    public function __construct(int $side) {
        $this->side = $side;
    }

    public function getArea(): int {
        return $this->side * $this->side;
    }
}

```

## Interface Segregation Principle (ISP)

- Don’t force unused methods.

```php
// Withour ISP
interface Machine {
    public function print();
    public function scan();
    public function fax();
}

class SimplePrinter implements Machine {
    public function print() { echo "Print"; }
    public function scan() { }
    public function fax() { }
}

// With ISP
interface Printer {
    public function print();
}

interface Scanner {
    public function scan();
}

class BasicPrinter implements Printer {
    public function print() {
        echo "Print\n";
    }
}
```

## Dependency Inversion Principle (DIP)

- Depend on interfaces, not concrete classes
- قابليه التوسع , عكس التبعية.

```php
// Without D
class MySQLDatabase {
    public function save() {
        echo "Saved to MySQL\n";
    }
}

class OrderService {
    private $db;

    public function __construct() {
        $this->db = new MySQLDatabase();
    }
}

// With D
interface Database {
    public function save();
}

class MySQLDatabase implements Database {
    public function save() {
        echo "Saved to MySQL\n";
    }
}

class MongoDatabase implements Database {
    public function save() {
        echo "Saved to Mongo\n";
    }

}

class OrderService {
    private Database $db;
    public function __construct(Database $db) {
        $this->db = $db;
    }
}

$service = new OrderService(new MySQLDatabase());
$service->db->save();
```

## Build Modern web app

#### Idea

- validation
- PRD
- markting
- review

#### Design

- ERD/Design docs
- Teck stack
- API
- Client
- Auth/Outhorization
- Deployments
- Review

#### UI / UX

- Wireframe
- visual design
- USer Testing

#### Development

- Host code on repo
- Coding
- Testing

#### Deployment

- SSL cert
- Host cloud provider/ self-host

## Web Auth

- `Authentication`: Getting user identity
- `Authorization` : Getting the user's permissions

#### Stateful

- using session in servers
- PHP Sessions

```php
session_start(); // Start a new session or resume the existing session
$_SESSION['username'] = 'JohnDoe'; // Store the username in the session
session_destroy(); // Destroy the session and remove all session data
```

#### Stateless

- using Token in clients
- JWT , Local Storage

```php
<?php
cookie('login' , 'true', 60 * 24 * 30); // Set a cookie named 'login' with value 'true' that expires in 30 days
```

| Stateful (Session)            | Stateless (JWT)                                                   |
| ----------------------------- | ----------------------------------------------------------------- |
| Server stores session         | Client stores token                                               |
| Session ID sent to server     | JWT sent to server                                                |
| Server checks session store   | Server validates token                                            |
| Easy logout (delete session)  | Logout usually requires token expiration or a revocation strategy |
| Best for traditional web apps | Best for APIs and mobile apps                                     |

## 3 Tips for Getting code reviews

1. Build => Run => Test your code
2. Make it short code review
3. Write a good decription for pull request

`Review your own Code`

## 3 tips for Giving code reviews

1. Automate as much as you can
2. Be Nice!
3. Be Specific
