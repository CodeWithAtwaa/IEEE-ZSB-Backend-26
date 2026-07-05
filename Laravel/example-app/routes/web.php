<?php

use App\Models\Idea;
use Illuminate\Support\Facades\Route;


Route::get('/', function () {
$ideas = \App\Models\Idea::paginate(5);
    return view('welcome', compact('ideas'));
});

Route::get('/about', function () {
    return view('about', ['title' => 'About Us']);
});

Route::post('/submit', function () {
    $message = request('message');
    // Process the message as needed
    if(empty($message)) {
        return redirect('/')->with('error', 'Message cannot be empty.');
    }
    Idea::Create(['message' => $message]);
    return redirect('/')->with('success', 'Message submitted successfully!');
})->name('submit');


Route::get('/admin', [App\Http\Controllers\Controller::class, 'index'])->middleware('auth');
