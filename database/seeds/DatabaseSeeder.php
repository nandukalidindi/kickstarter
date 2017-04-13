<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call(UserSeeder::class);
        $this->call(ProjectSeeder::class);
        $this->call(CreditCardSeeder::class);
        $this->call(PledgeSeeder::class);
        $this->call(ReviewSeeder::class);
        $this->call(FollowerSeeder::class);
    }
}

class UserSeeder extends Seeder
{
  public void run()
  {

  }
}

class ProjectSeeder extends Seeder
{
  public void run()
  {

  }
}

class CreditCardSeeder extends Seeder
{
  public void run()
  {

  }
}

class PledgeSeeder extends Seeder
{
  public void run()
  {

  }
}

class ReviewSeeder extends Seeder
{
  public void run()
  {

  }
}

class FollowerSeeder extends Seeder
{
  public void run()
  {

  }
}
