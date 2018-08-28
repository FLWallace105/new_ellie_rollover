require 'dotenv'
Dotenv.load
require 'active_record'
require 'sinatra/activerecord/rake'

require_relative 'ellie_rollover'

namespace :ellie_rollover do
    
    desc "rollover Ellie Products to Next Month"
    task :rollover_ellie_products do |t|
        EllieRollover::NextMonth.new.rollover_products
    end 

    #setup_rollover
    desc "setup Ellie Products with information to rollover for next month"
    task :setup_rollover do |t|
        EllieRollover::NextMonth.new.setup_rollover
    end

    #rollover_navigation
    desc "change redirects"
    task :change_redirects do |t|
        EllieRollover::NextMonth.new.rollover_navigation
    end

    #rollover_collection
    desc "rollover collections"
    task :rollover_custom_collections do |t|
        EllieRollover::NextMonth.new.rollover_collection

    end


end