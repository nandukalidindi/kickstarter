<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCreditCardsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
      Schema::create('credit_cards', function (Blueprint $table) {
        $table->increments('id')->unique();
        $table->integer('user_id');
        $table->text('cc_number');
        $table->boolean('is_default')->default(false);
        $table->boolean('is_enabled')->default(true);
        $table->timestamps();

        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
      });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
      Schema::dropIfExists('credit_cards');
    }
}
