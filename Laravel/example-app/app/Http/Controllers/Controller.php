<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Gate;

abstract class Controller
{
    public function index() {
        Gate::authorize('admin');
        return response()->json(['message' => 'You are an admin!']);
    }
}
