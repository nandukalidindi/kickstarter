<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
          $table->increments('id')->unique();
          $table->string('first_name', 30);
          $table->string('last_name', 30);
          $table->string('email', 40);
          $table->string('username', 20);
          $table->string('password', 20);
          $table->string('address', 50)->nullable();
          $table->string('state', 20)->nullable();
          $table->string('country', 20)->nullable();
          $table->string('pincode', 8)->nullable();
          $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
