<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pesanan_laundry', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('name');
            $table->string('address');
            $table->string('laundry_type')->nullable();
            $table->string('detergen_type')->nullable();
            $table->timestamp('pickup_at')->nullable();
            $table->timestamp('delivery_at')->nullable();
            $table->string('status')->default('pending');
            $table->text('laundry_items')->nullable();
            $table->integer('laundry_weight')->default(0);
            $table->decimal('price')->default(0);
            $table->integer('rating')->nullable();
            $table->timestamps();
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pesanan_laundry', function (Blueprint $table) {
            $table->dropColumn('laundry_weight');
            $table->dropColumn('price');
        });
    }
};
