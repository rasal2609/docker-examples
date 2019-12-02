<!-- resources/views/myinputs/show.blade.php -->
@extends('layouts.app')
@section('content')
<div class="container">
      <nav class="navbar navbar-inverse">
          <ul class="nav navbar-nav">
              <li><a href="{{ URL::to('myinputs') }}">View All Myinputs</a></li>
          </ul>
      </nav>
<h1>Showing {{ $myinput->string }}</h1>

    <div class="jumbotron text-center">
        <h2>{{ $myinput->string }}</h2>
        <p>
            <strong>Email:</strong> {{ $myinput->email }}<br>
            <strong>Level:</strong> {{ $myinput->level }}
        </p>
    </div>
</div>
@endsection
