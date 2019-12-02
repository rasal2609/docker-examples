<?php

namespace App\Http\Controllers;
use DB;
use App\Post;

class PostsController
{
    public function show($slug)
    {
    	//$post = Post::where('slug', $slug)->firstOrFail();

        return view('post', [
            'post' => Post::where('slug', $slug)->firstOrFail()
        ]);

    }
}
