<!-- resources/views/myinputs/index.blade.php -->
@extends('layouts.app')
@section('content')

<div id="wrapper">
    <div id="page" class="container">
        <div id="content">
            <div class="container">
                <nav class="navbar navbar-inverse">
                    <ul class="nav navbar-nav">
                        <li><a href="{{ URL::to('myinputs/create') }}">Create a Myinput</a>
                    </ul>
                </nav>

            <h1>All the Myinputs</h1>

            <!-- will be used to show any messages -->
            @if (Session::has('message'))
                <div class="alert alert-info">{{ Session::get('message') }}</div>
            @endif

            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td>ID</td>
                        <td>String</td>
                        <td>Email</td>
                        <td>Integer</td>
                        <td>Actions</td>
                    </tr>
                </thead>
                <tbody>
                @foreach($myinputs as $key => $value)
                    <tr>
                        <td>{{ $value->id }}</td>
                        <td>{{ $value->string }}</td>
                        <td>{{ $value->email }}</td>
                        <td>{{ $value->integer }}</td>

                        <!-- we will also add show, edit, and delete buttons -->
                        <td>

                            <!-- show the myinput (uses the show method found at GET /myinputs/{id} -->
                            <a class="btn btn-small btn-success" href="{{ URL::to('myinputs/' . $value->id) }}">Show this Myinput</a>

                            <!-- edit this myinput (uses the edit method found at GET /myinputs/{id}/edit -->
                            <a class="btn btn-small btn-info" href="{{ URL::to('myinputs/' . $value->id . '/edit') }}">Edit this Myinput</a>

                            <!-- delete the myinput (uses the destroy method DESTROY /myinputs/{id} -->
                            <form action="./myinputs/{{$value->id }}"  onsubmit="return confirm('Are you sure to delete: {{ $value->string}}')" method="POST">
                                {{ csrf_field() }}
                                {{ method_field('DELETE') }}
                                <button type="submit" class="btn btn-danger">
                                    <i class="fa fa-btn fa-trash">Delete</i>
                                </button>
                            </form>
                        </td>
                    </tr>
                @endforeach
                </tbody>
            </table>
                 {!! $myinputs->render() !!}
            </div>
        </div>
    </div>
@endsection
