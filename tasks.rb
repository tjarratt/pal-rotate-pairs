HOME = ENV['HOME']
WORKSPACE = "#{HOME}/workspace"

def validate_pal_tracker_clean!
  return unless Dir.exists? "#{WORKSPACE}/pal-tracker"

  Dir.chdir "#{WORKSPACE}/pal-tracker" do
    Dirty.new('pal-tracker').halt if uncommitted_changes?
    Unpushed.new('pal-tracker').halt if unpushed_commits?
  end
end

def validate_pal_tracker_distributed_clean!
  return unless Dir.exists? "#{WORKSPACE}/pal-tracker-distributed"

  Dir.chdir "#{WORKSPACE}/pal-tracker-distributed" do
    Dirty.new('pal-tracker-distributed').halt if uncommitted_changes?
    Unpushed.new('pal-tracker-distributed').halt if unpushed_commits?
  end
end

def uncommitted_changes?
  `git diff-index --quiet HEAD --`
  return $? != 0
end

def unpushed_commits?
  `git diff master origin/master --exit-code`
  return $? != 0
end

def ask_who_stays_at_workstation

end

def ask_who_is_joining_the_workstation

end

def fillin_emails_in_assignment_submission(driver, navigator)

end

def reset_git_author

end

def reset_ssh_identities

end

def logout_of_cloud_foundry

end

def verify_assignment_submission_works

end

def success!
  puts "Great, you've rotated pairs."
  puts "Now get to work on the next lab ;-)"
end

class Exceptionish
   def initialize(repo_name)
    @repo_name = repo_name
  end

  def halt
    puts 'Wait a minute, not just yet ...'
    puts ''

    puts reason_for_exit
    puts ''

    puts 'Resolution:'
    puts resolution

    exit 1

  end
end

class Dirty < Exceptionish
 def reason_for_exit
    "Refusing to rotate pairs while there are uncommitted changes to #{@repo_name}."
  end

  def resolution
    "Go the the #{@repo_name} directory, ensure your changes are committed and pushed. Then re-run this script."
  end
end

class Unpushed < Exceptionish
  def reason_for_exit
    "Refusing to rotate pairs while there are unpushed changes to #{@repo_name}."
  end

  def resolution
    "Go the the #{@repo_name} directory, ensure your changes are and pushed to origin/master. Then re-run this script."
  end
end


