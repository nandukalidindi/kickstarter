<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProjectsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
      Schema::create('projects', function (Blueprint $table) {
        $table->increments('id')->unique();
        $table->text('title');
        $table->text('description');
        $table->integer('posted_by');
        $table->string('type', 10)->nullable();
        $table->string('status', 10)->nullable();
        $table->double('minimum_fund', 5, 2)->nullable();
        $table->double('maximum_fund', 5, 2);
        $table->timestampTz('start_date')->nullable();
        $table->timestampTz('end_date');
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
      Schema::dropIfExists('projects');
    }
}
