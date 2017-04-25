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
        // $this->call(UserSeeder::class);
        $this->call(ProjectSeeder::class);
        // $this->call(CreditCardSeeder::class);
        // $this->call(PledgeSeeder::class);
        // $this->call(ReviewSeeder::class);
        // $this->call(FollowerSeeder::class);
    }
}

class UserSeeder extends Seeder
{
  public function run()
  {
    DB::delete('delete from users');

    DB::insert('INSERT INTO users(first_name, last_name, email, username, password, address, state, country, pincode, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', ['Chiquita', 'Ratnakar', 'crp380@nyu.edu', 'chuquita', 'password', 'NYU', 'NY', 'USA', '11201', date('Y-m-d H:i:s'), date('Y-m-d H:i:s')]);
    DB::insert('INSERT INTO users(first_name, last_name, email, username, password, address, state, country, pincode, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', ['Nandu', 'Kalidindi', 'nkk263@nyu.edu', 'nandukalidindi', 'password', 'Bayridge', 'NY', 'USA', '11209', date('Y-m-d H:i:s'), date('Y-m-d H:i:s')]);
    DB::insert('INSERT INTO users(first_name, last_name, email, username, password, address, state, country, pincode, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', ['Kris', 'Cheng', 'kc100@nyu.edu', 'krischeng', 'password', 'Mountain View', 'California', 'USA', '11209', date('Y-m-d H:i:s'), date('Y-m-d H:i:s')]);
  }
}

class ProjectSeeder extends Seeder
{
  public function run()
  {

    DB::delete('delete from projects');

    DB::insert('INSERT INTO users(title, description, posted_by, type, tags, status, minimum_fund, maximum_fund, start_date, end_date, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', ['Spark Camera Remote', 'One Spark, three modes of control. Trigger your DSLR and Mirrorless camera with wireless infrared, wired triggering, and app control.', 7, 'Technology', '{tech, startup, imageprocessing}', 'INITIAL', 100000, 200000, data('Y-m-d H:i:s'), '2017-05-01 00:00:00', date('Y-m-d H:i:s'), date('Y-m-d H:i:s')]);
  }
}

class CreditCardSeeder extends Seeder
{
  public function run()
  {

  }
}

class PledgeSeeder extends Seeder
{
  public function run()
  {

  }
}

class ReviewSeeder extends Seeder
{
  public function run()
  {

  }
}

class FollowerSeeder extends Seeder
{
  public function run()
  {

  }
}
