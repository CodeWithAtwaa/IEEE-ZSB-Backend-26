<?php

namespace App\Http\Controllers;
use App\Notifications\IdeaCreatedNotification;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Gate;
use App\Models\Idea;

abstract class Controller
{
    public function index() {
        Gate::authorize('admin');
        return response()->json(['message' => 'You are an admin!']);
    }

}
