#ellie_rollover.rb
require 'shopify_api'
require 'dotenv'
#Dotenv.load
require 'csv'
require 'active_record'
require "sinatra/activerecord"
require 'active_support/core_ext/time'
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

        def rollover_navigation
            #Can't change linked lists, just redirects which is useless
            ShopifyAPI::Base.site = "https://#{@apikey}:#{@password}@#{@shopname}.myshopify.com/admin"
            my_redirects = ShopifyAPI::Redirect.find(:all)
            my_redirects.each do |myredir|
                puts my_redirects.inspect

            end
            my_count = ShopifyAPI::Redirect.count()
            puts "We have #{my_count} redirects"


        end

        def rollover_collection
            ShopifyAPI::Base.site = "https://#{@apikey}:#{@password}@#{@shopname}.myshopify.com/admin"
            my_count = ShopifyAPI::CustomCollection.count()
            puts "We have #{my_count} custom collections"
            #Thread.current[:time_zone] = ActiveSupport::TimeZone['Pacific Time (US & Canada)']
            Time.zone = ActiveSupport::TimeZone['Pacific Time (US & Canada)']
            Time.zone_default = ActiveSupport::TimeZone['Pacific Time (US & Canada)']
            
            puts "running configure timezone: #{Time.zone.inspect}"

            my_next_month = Time.zone.now.next_month
            my_next_month_collection_str = my_next_month.strftime("%B %y") + " Exclusives"
            puts "my_next_month_collection_str = #{my_next_month_collection_str}"


            page_size = 250
            pages = (my_count / page_size.to_f).ceil

            temp_collection = ShopifyAPI::CustomCollection.new
            alt_temp_collection = ShopifyAPI::CustomCollection.new

            1.upto(pages) do |page|
                mycollection = ShopifyAPI::CustomCollection.find(:all, params: {limit: 250, page: page})
                mycollection.each do |myc|
                    #puts myc.inspect
                    mytitle = myc.attributes['title']
                    myhandle = myc.attributes['handle']
                    puts "#{mytitle} -- #{myhandle}"
                    if mytitle == "Ellie Exclusives"
                        temp_collection = myc
                    end
                    if mytitle == my_next_month_collection_str
                        alt_temp_collection = myc
                    end
                end
                puts "Done with page #{page}"
                puts temp_collection.inspect
                mynow = DateTime.now.strftime("%B %Y")
                myhandle = mynow.downcase
                temp_collection.attributes['title'] = temp_collection.attributes['title'] + " #{mynow}"
                temp_collection.attributes['handle'] = temp_collection.attributes['handle'] + "-#{myhandle}"
                temp_collection.save
                puts "Now old main collection = #{temp_collection.inspect}"
                puts "Alt collection = #{alt_temp_collection.inspect}"
                alt_temp_collection.attributes['title'] = "Ellie Exclusives"
                alt_temp_collection.attributes['handle'] = "ellie-exclusives"
                alt_temp_collection.save
                puts "Now alt collection = #{alt_temp_collection.inspect}"
            end



            

        end



        def setup_rollover
            EllieRolloverSetup.delete_all
            ActiveRecord::Base.connection.reset_pk_sequence!('ellie_rollover_setup')

            CSV.foreach('sept_2018_rollover.csv', :encoding => 'ISO-8859-1', :headers => true) do |row|
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