#ellie_rollover.rb
require 'shopify_api'
require 'dotenv'
#Dotenv.load
require 'csv'
require 'active_record'
require "sinatra/activerecord"
require_relative 'models/model'


module EllieRollover
    class NextMonth
        def initialize
            Dotenv.load
            @apikey = ENV['SHOPIFY_API_KEY']
            @shopname = ENV['SHOPIFY_SHOP_NAME']
            @password = ENV['SHOPIFY_PASSWORD']

        end

        def rollover_products
            ShopifyAPI::Base.site = "https://#{@apikey}:#{@password}@#{@shopname}.myshopify.com/admin"
            my_setups = EllieRolloverSetup.all
            my_setups.each do |mysetup|
                my_product = ShopifyAPI::Product.find(mysetup.product_id)
                #puts my_product.inspect
                puts my_product.title
                puts "changing Title --"
                my_product.title = mysetup.new_title
                puts my_product.template_suffix
                puts "changing template"
                my_product.template_suffix = mysetup.new_template
                my_product.save
                puts "Now product is: #{my_product.title}, #{my_product.template_suffix}"
                my_variants = my_product.variants
                my_variants.each do |myvar|
                    puts "Variant Price = #{myvar.price}"
                    puts "Changing price --"
                    myvar.price = mysetup.new_price
                    myvar.save
                    puts "Now variant price = #{myvar.price}"
                end
                puts "---------"
                sleep 4
            end
            puts "All Done setting up for next month"
        end

        def setup_rollover
            EllieRolloverSetup.delete_all
            ActiveRecord::Base.connection.reset_pk_sequence!('ellie_rollover_setup')

            CSV.foreach('aug_2018_rollover.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
                product_title = row['product_title']
                product_id = row['product_id']
                new_title = row['new_title']
                new_price = row['new_price']
                new_template = row['new_template']
                my_setup = EllieRolloverSetup.create(product_title: product_title, product_id: product_id, new_title: new_title, new_price: new_price, new_template: new_template)
                puts my_setup.inspect
            
            end

        end

    end
end