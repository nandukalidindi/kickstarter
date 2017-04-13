<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePledgesTableAgain extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
      Schema::create('pledges', function (Blueprint $table) {
        $table->integer('user_id');
        $table->integer('project_id');
        $table->double('amount', 5, 2);
        $table->integer('cc_card_id');
        $table->timestamps();

        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        $table->foreign('project_id')->references('id')->on('projects')->onDelete('cascade');
        $table->foreign('cc_card_id')->references('id')->on('credit_cards')->onDelete('cascade');
      });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
      Schema::dropIfExists('pledges');
    }
}
