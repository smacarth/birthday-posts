desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  FacebookUser.cron
end