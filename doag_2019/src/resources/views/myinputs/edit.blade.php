<!-- resources/views/myinputs/edit.blade.php -->
@extends('layouts.app')
@section('content')
<div class="container">
      <nav class="navbar navbar-inverse">
          <ul class="nav navbar-nav">
              <li><a href="{{ URL::to('myinputs') }}">View All Myinputs</a></li>
          </ul>
      </nav>
<h1>Edit {{ $myinput->string }}</h1>

<!-- if there are creation errors, they will show here -->
@if (count($errors) > 0)
    <div class="alert alert-danger">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<form action="{{ url('myinputs') }}/{{$myinput->id }}" method="POST" class="form-horizontal">
    {{ csrf_field() }}
    {{ method_field('PATCH')}}

    <div class="form-group">
        <label for="formGroupExampleInput">String:</label>
        <input type="text" name="string" class="form-control" value="{{ $myinput->string }}">

    </div>

    <div class="form-group">
        <label for="formGroupExampleInput">Email:</label>
        <input type="text" name="email" class="form-control" value="{{ $myinput->email }}">
    </div>

    <div class="form-group">
        <label for="formGroupExampleInput">Level:</label>
        <input type="text" name="integer" class="form-control" value="{{ $myinput->integer }}">
    </div>

    <div class="form-group">
</div>

<!-- Update Button -->
 <div class="form-group">
     <div class="col-sm-offset-3 col-sm-6">
         <button type="submit" class="btn btn-default">
             <i class="fa fa-btn fa-plus">update</i>
         </button>
     </div>
 </div>

</form>
</div>
@endsection
