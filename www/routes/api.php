<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::any('/upload', function (Request $request) {
    $request->validate([
        'file' => 'required|file|max:300000000',
    ]);

    $imageName = time().'.'.$request->file->extension();

    $path = $request->file->storeAs('public', $imageName);

    return response()->json([
        'success' => true,
        'path' => $path,
        'url' => asset('storage/'.$imageName)
    ]);
});
