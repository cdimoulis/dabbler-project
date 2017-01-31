namespace :util do
  namespace :data do
    task backup: :environment do
      user = `echo $USER`
      cmd = "pg_dump -Fc --data-only --no-acl --no-owner -h 'localhost' -U #{user.strip} --dbname=development_dabbler_project > /Users/#{user.strip}/Github/dabbler-project/notes/dev/db_data_dump"
      res = system("#{cmd}")
      if !res
        puts "\n\nSome error dumping db\n\n"
      end
    end

    task restore: :environment do
      user = `echo $USER`
      res = system("pg_restore --data-only --no-acl --no-owner -h 'localhost' -U #{user.strip} --dbname=development_dabbler_project /Users/#{user.strip}/Github/dabbler-project/notes/dev/db_data_dump")
      if !res
        puts "\n\nSome error restoring db...but check database anyway...\n\n"
      end
    end
  end
end
