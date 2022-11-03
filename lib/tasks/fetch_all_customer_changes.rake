# Basic Job to fetch all customer changes from the API from Customer -> Job


# on zsh shell need to escape the [ ] with \[ \]
# rake fetch_all_customer_changes\[2\]
desc "Fetching all customer changes by calling FetchAllPlatformCustomersJob."
task :fetch_all_customer_changes, [:project_id] => :environment do |_t, args|

  project_id = args[:project_id] || nil
  project = Project.find(project_id)

  return unless project.present?

  FetchAllPlatformCustomersJob.perform_now(project.user, project)
end