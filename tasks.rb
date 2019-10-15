HOME = ENV['HOME']
WORKSPACE = "#{HOME}/workspace"

def validate_pal_tracker_clean!
  Dir.chdir "#{WORKSPACE}/pal-tracker" do
    `git diff-index --quiet HEAD --`
    raise 'Ensure your pal-tracker git repository changes are committed and pushed' unless $? == 0
  end
end

