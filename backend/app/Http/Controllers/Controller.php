<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;


class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;
}

class UpdateController extends Controller
{
    public function showUpdatePage()
    {
        return view('update');
    }
}

class DetailController extends Controller
{
    public function showUpdatePage()
    {
        return view('detail');
    }
}

class InputController extends Controller
{
    public function showUpdatePage()
    {
        return view('proses');
    }
}

class LaporanController extends Controller
{
    public function showUpdatePage()
    {
        return view('laporan');
    }
}