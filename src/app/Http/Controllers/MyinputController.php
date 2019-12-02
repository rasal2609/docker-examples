<?php

namespace App\Http\Controllers;
use App\Myinput;
use View;
use Illuminate\Http\Request;



class MyinputController extends Controller
{
  /**
      * Display a listing of the resource.
      */
     public function index()
     {
       // get all the myinputs
       $myinputs = Myinput::latest()->paginate(10);
       // load the view and pass the myinputs
       return View('myinputs.index',compact('myinputs'));
     }

     /**
      * Show the form for creating a new resource.
      */
     public function create()
     {
       // load the create form (app/views/myinputs/create.blade.php)
       return View('myinputs.create');
     }

     /**
      * Store a newly created resource in storage.
      */
     public function store(Request $request)
     {
       // validate

               $this->validate($request, [
                   'string'       => 'required',
                   'email'      => 'required|email',
                   'integer' => 'required|numeric']);


                   // store
                  Myinput::create([
                   'string'      =>  $request->string,
                   'email'      =>  $request->email,
                   'integer' =>  $request->integer,
                 ]);
          return back();

     }

     /**
      * Display the specified resource.
      */  
     public function show($id)
     {
       // get the myinput
       $myinput = Myinput::find($id);

       // show the view and pass the myinput to it
       return View('myinputs.show',compact('myinput'));
     }

     /**
      * Show the form for editing the specified resource.
      */
     public function edit(myinput $myinput)
     {
       return View('myinputs.edit',compact('myinput'));
     }

     /**
      * Update the specified resource in storage.
      */
     public function update(Request $request, myinput $myinput)
     {
       $this->validate($request, [
           'string'       => 'required',
           'email'      => 'required|email',
           'integer' => 'required|numeric']);
           
          $myinput->update($request->all());
          return back();
     }

     /**
      * Remove the specified resource from storage.
      */
     public function destroy(myinput $myinput)
     {
       $myinput->delete();
        return back();
     }
}
