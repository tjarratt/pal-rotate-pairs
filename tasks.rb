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
  emails = read_emails_from_build_dot_gradle

  puts "Who is staying at the workstation ? Please type '1' or '2'"
  puts "1. #{emails.first}"
  puts "2. #{emails.second}"
  puts ''

  input = gets.strip
  puts ''

  stays = case input when '1'; emails.first else emails.second end
  puts "Okay, great then #{stays} will stay at the workstation"

  return stays
end

def read_emails_from_build_dot_gradle
  lines = File.read("#{WORKSPACE}/assignment-submission/build.gradle").split("\n")
  email_lines = lines.map(&:lstrip).drop_while {|l| ! l.start_with?('email') }

  first, second = email_lines
    .drop_while {|l| ! l.include?('[') }
    .take_while {|l| ! l.include?(']') }
    .join(" ")
    .gsub('emails = [', '')
    .split(',')
    .map {|email| email.gsub('"', '').strip }

  return Struct.new(:first, :second).new(first, second)
end

def ask_who_is_joining_the_workstation
  puts "... and what is the email address for the person who will be joining the workstation ?"

  new_email = gets.strip
  puts ''

  return new_email
end

def fill_in_emails_in_assignment_submission(driver, navigator)

end

def reset_git_author
  `git config --global --unset user.email`
  `git config --global --unset user.name`
end

def reset_ssh_identities
  `ssh-add -D`
end

def logout_of_cloud_foundry
  `cf logout`
end

def verify_assignment_submission_works!
  Dir.chdir("#{WORKSPACE}/assignment-submission") do
    `./gradlew testAssignment -PexampleUrl=http://www.example.com`
    Something.halt if $? != 0
  end
end

def success!
  puts "Great, you've rotated pairs."
  puts "Now get to work on the next lab ;-)"
end

class Exceptionish
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

class AssignmentSubmissionFailed < Exceptionish
  def reason_for_exit
    "There was a problem verifying that the assignment submission tool still works."
  end

  def resolution
    "Go to the #{WORKSPACE}/assignment-submission directory, inspect the build.gradle, and run the testAssignment task to verify it is working"
  end
end

class Dirty < Exceptionish
  def initialize(repo_name)
    @repo_name = repo_name
  end

 def reason_for_exit
    "Refusing to rotate pairs while there are uncommitted changes to #{@repo_name}."
  end

  def resolution
    "Go the the #{@repo_name} directory, ensure your changes are committed and pushed. Then re-run this script."
  end
end

class Unpushed < Exceptionish
  def initialize(repo_name)
    @repo_name = repo_name
  end

  def reason_for_exit
    "Refusing to rotate pairs while there are unpushed changes to #{@repo_name}."
  end

  def resolution
    "Go the the #{@repo_name} directory, ensure your changes are and pushed to origin/master. Then re-run this script."
  end
end


