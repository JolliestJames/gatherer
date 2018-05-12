require "rails_helper"

RSpec.describe "adding a project", type: :system do
  it "allows a user to create a project with tasks" do
    visit new_project_path
    fill_in "Name", with: "Project Runway"
    fill_in "Tasks", with: "Choose Fabric:3\nMake it Work:5"
    click_on("Create Project")
    visit projects_path
    expect(page).to have_content("Project Runway")
    expect(page).to have_content(8)
  end

  it "does not allow a user to create a project without a name" do
    visit new_project_path
    fill_in "Name", with: ""
    fill_in "Tasks", with: "Choose Fabric:3\nMake it Work:5"
    click_on("Create Project")
    expect(page).to have_selector(".new_project")
  end

  it "behaves correctly in the face of a surprising database failure" do
    workflow = instance_spy(CreatesProject,
      success?: false, project: Project.new)
    allow(CreatesProject).to receive(:new)
      .with(name: "Real Name",
        task_string: "Choose Fabric:3\r\nMake it Work:5")
      .and_return(workflow)
    visit new_project_path
    fill_in "Name", with: "Real Name"
    fill_in "Tasks", with: "Choose Fabric:3\nMake it Work:5"
    click_on("Create Project")
    expect(page).to have_selector(".new_project")
  end

end