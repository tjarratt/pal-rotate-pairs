HOME = ENV['HOME']
WORKSPACE = "#{HOME}/workspace"

def validate_pal_tracker_clean!
  Dir.chdir "#{WORKSPACE}/pal-tracker" do
    return unless uncommitted_changes?

    puts 'Wait a minute, not just yet ...'
    puts ''

    puts 'Refusing to rotate pairs while there are uncommitted changes to pal-tracker.'
    puts ''

    puts 'Resolution:'
    puts 'Go the the pal-tracker directory, ensure your changes are committed and pushed. Then re-run this script.'

    exit 1
  end
end

def validate_pal_tracker_distributed_clean!
  Dir.chdir "#{WORKSPACE}/pal-tracker-distributed" do
    return unless uncommitted_changes?

    puts 'Wait a minute, not just yet ...'
    puts ''

    puts 'Refusing to rotate pairs while there are uncommited changes to pal-tracker-distributed.'
    puts ''

    puts 'Resolution:'
    puts 'Go to the pal-tracker-distributed directory, ensure your changes are committed and pushed. Then re-run this script.'

    exit 1
  end
end

def uncommitted_changes?
  `git diff-index --quiet HEAD --`
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
