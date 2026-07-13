<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Step extends Model
{

    protected $attributes = ['completed' => false];
    public function idea() {
        return $this->belongsTo(Idea::class);
    }
}
