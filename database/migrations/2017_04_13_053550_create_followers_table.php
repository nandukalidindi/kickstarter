<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFollowersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
      Schema::create('followers', function (Blueprint $table) {
        $table->integer('follower_id');
        $table->integer('following_id');
        $table->timestamps();

        $table->foreign('follower_id')->references('id')->on('users')->onDelete('cascade');
        $table->foreign('following_id')->references('id')->on('users')->onDelete('cascade');
      });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
