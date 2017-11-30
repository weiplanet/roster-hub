require 'csv'
require 'zip'

class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # abstract zip file to csv files
    return unless abstract_zip
    # First, import manifest.csv
    # TODO: record the results in a log file.
    return unless File.exist?(get_filepath('manifest'))
    csv_data = CSV.read(get_filepath('manifest'), headers: false)
    manifest_hash = Hash[*csv_data.flatten]
    csv_files = validate_manifest(manifest_hash)
    return if csv_files.nil? or csv_files.length < 1 
    ActiveRecord::Base.transaction do
    csv_files.each{|cf|
      send('csv_to_db_' + cf)
    }
    end
    csv_to_backup
  end
  
  private
  def abstract_zip
    return true unless ZIP_MODE # continue importing process if ZIP_MODE=false
    return false if extract_to_csv.nil? # stop processing if zip file not exists
    backup_zipfile
    true
  end
  
  def csv_to_backup
    FileUtils.cd(Rails.root.join(CSV_FILE_PATH))
    check_file = 'manifest.csv'
    return unless File.exist?(check_file)
    backuppath = File.join('backup' , File.stat(check_file).mtime.strftime('%Y%m%d%H%M%S').to_s)
    FileUtils.mkdir_p(backuppath) unless FileTest.exist?(backuppath)
    Dir.glob('*.csv'){|f|
      FileUtils.mv(f, File.join(backuppath,f))
    }
  end
  
  def extract_to_csv
    FileUtils.cd(Rails.root.join(CSV_FILE_PATH))
    return nil unless File.exist?(CSV_ZIP_FILE)
    Zip::File.open(CSV_ZIP_FILE) do |zip|
      zip.each do |entry|
        zip.extract(entry, entry.name){ true }
      end
    end
  end

  def backup_zipfile
    FileUtils.cd(Rails.root.join(CSV_FILE_PATH))
    return nil unless File.exist?(CSV_ZIP_FILE)
    backup_file_name = File.stat(CSV_ZIP_FILE).mtime.strftime('%Y%m%d%H%M%S').to_s + '.zip'
    FileUtils.mkdir_p(BACKUP_DIR) unless FileTest.exist?(BACKUP_DIR)
    Dir.glob(CSV_ZIP_FILE){|f|
      FileUtils.mv(f, File.join(BACKUP_DIR,backup_file_name))
    }
  end

  def csv_to_db_academicSessions
    AcademicSession.delete_all
    CSV.foreach(get_filepath('academicSessions'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      AcademicSession.create!(row.to_hash)
    end
  end
  
  def csv_to_db_categories
  end
  def csv_to_db_classes
    Rclass.delete_all
    CSV.foreach(get_filepath('classes'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      Rclass.create!(row.to_hash)
    end
  end
  def csv_to_db_classResrouces
  end
  def csv_to_db_courses
    Course.delete_all
    CSV.foreach(get_filepath('courses'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      Course.create!(row.to_hash)
    end
  end
  def csv_to_db_courseResources
  end
  def csv_to_db_demographics
  end
  def csv_to_db_enrollments
    Enrollment.delete_all
    CSV.foreach(get_filepath('enrollments'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      Enrollment.create!(row.to_hash)
    end
  end
  def csv_to_db_lineItems
  end
  def csv_to_db_orgs
    Org.delete_all
    CSV.foreach(get_filepath('orgs'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      Org.create!(row.to_hash)
    end
  end
  def csv_to_db_resources
  end
  def csv_to_db_results
  end
  def csv_to_db_users
    User.delete_all
    CSV.foreach(get_filepath('users'), headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      User.create!(row.to_hash)
    end
  end
  
  def get_filepath(type)
    Rails.root.join(CSV_FILE_PATH, type + '.csv').to_s
  end
  
  # bulk only
  def validate_manifest(manifest_hash)
    manifest_version = manifest_hash['manifest.version']
    oneroster_version = manifest_hash['oneroster.version']
    return nil unless '1'.eql?(manifest_version)
    return nil unless '1.1'.eql?(oneroster_version)
    read_files = []
    ROSTER_FILES.each{|fcl|
      read_files.push(fcl) if 'bulk'.eql?(manifest_hash['file.' + fcl])
    }
    read_files
  end
end