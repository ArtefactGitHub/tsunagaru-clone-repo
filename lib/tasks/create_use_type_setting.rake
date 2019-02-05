namespace :create_use_type_setting do
  desc "Create use_type_setting for users not have"

  task :create => :environment do
    include UseTypeSettingsControllerModule

    # find_each を利用してレコード数を考慮してみる
    User.find_each { |user|
      puts '=============='
      # puts "id: #{user.id}"
      # puts "user.use_type_setting.present?: #{user.use_type_setting.present?}"
      next if user.use_type_setting.present?

      # puts "create: #{user.id}"
      create_use_type_setting user
    }
  end
end
