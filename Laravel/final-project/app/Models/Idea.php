<?php

namespace App\Models;

use App\IdeaStatusEnum;
use Illuminate\Database\Eloquent\Casts\AsArrayObject;
use Illuminate\Database\Eloquent\Model;

use App\Models\Step;

class Idea extends Model
{
    protected $casts = [
        'links' => AsArrayObject::class,
        'status' => IdeaStatusEnum::class,
    ];

    protected $attributes = [
        'status' => IdeaStatusEnum::PENDING,
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }
    public function steps() {
        return $this->hasMany(Step::class);
    }
}
