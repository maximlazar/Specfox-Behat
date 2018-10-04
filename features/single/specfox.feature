Feature: Specfox
    Full automated test for Specfox ns-qa/production

    @homepage
    Scenario: Homepage
        Given I am on homepage
        Then I should see "Easy Product Specification"
        Then I follow "Home"
        And I should be on homepage
        Then I follow "Features"
        And I should be on "features"
        Then I move backward one page
        And I should be on homepage
        Then I follow "About"
        And I should be on "about"
        Then I move backward one page
        Then I follow "Privacy Policy"
        And I should be on "privacy-policy"
        Then I move backward one page
        Then I follow "Terms of service"
        And I should be on "terms-of-service"
        Then I move backward one page

    @features
    Scenario: Features
        Given I am on "features"
        Then I should see "The easiest & Fastest Way to Create Design Specification"
        Then I follow "Home"
        And I should be on homepage
        Then I move backward one page
        And I should be on "features"
        Then I follow "Features"
        And I should be on "features"
        Then I follow "About"
        And I should be on "about"
        Then I move backward one page
        Then I follow "Privacy Policy"
        And I should be on "privacy-policy"
        Then I move backward one page
        Then I follow "Terms of service"
        And I should be on "terms-of-service"
        Then I move backward one page

    @about
    Scenario: About
        Given I am on "about"
        Then I should see "Who we are, what we do and where to find us"
        Then I follow "Home"
        And I should be on homepage
        Then I move backward one page
        And I should be on "about"
        Then I follow "Features"
        And I should be on "features"
        Then I move backward one page
        Then I follow "About"
        And I should be on "about"
        Then I follow "Privacy Policy"
        And I should be on "privacy-policy"
        Then I move backward one page
        Then I follow "Terms of service"
        And I should be on "terms-of-service"
        Then I move backward one page
        Then I fill in "Your name" with a random name
        Then I fill in "Email address" with a random mail
        Then I fill in "Your message" with a random text
        Then I select "other" from "reason"
        Then I press "Send message"
        And I should see "SEND ANOTHER MESSAGE"
        And I should be on "about?success=true#form"
        Then I click on the element with css selector "#form > a"
        And I should be on "about#form"
        And I should see "Send message"

    @sign-in
    @javascript
    Scenario: Sign In - unexistent account
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(1) > a"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with a random mail
        And I fill in "password" with a random text
        Then I press "Sign in"
        Then I wait for "Sorry, something went wrong when submitting your form" to appear

    @sign-in
    @javascript
    Scenario: Sign In - invalid mail format
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(1) > a"
        Then I wait for "Sign into your Specfox Account"
        Then I fill selector "#sign-in > div > div > div > div > div.colRight > form > div:nth-child(1) > input" with "test"
        And I press "Sign in"
        Then I wait for 10 seconds
        Then grab a screenshot
       # Then I wait for "The email must be a valid email address." to appear
        Then I fill selector "#sign-in > div > div > div > div > div.colRight > form > div:nth-child(1) > input" with "test@"
        And I press "Sign in"
        Then I wait for "The email must be a valid email address." to appear
        Then I fill selector "#sign-in > div > div > div > div > div.colRight > form > div:nth-child(1) > input" with "test@test.test"
        And I fill in "password" with "test"
        And I press "Sign in"
        Then I wait for "Sorry, something went wrong when submitting your form"

    @sign-in
    @javascript
    Scenario: Sign In - forgotten password
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(1) > a"
        Then I wait for "Sign into your Specfox Account"
        When I click on the element with xpath "//*[@id='sign-in']/div/div/div/div/div[1]/p[3]/a/strong"
        Then I wait for "Enter your email address below to request password reset."
        Then I should see "Email address" appear
        Then I fill selector "#forgot-password > div > div > div > form > div > input" with "test@test.test"
        And I click on the element with xpath "//*[@id='forgot-password']/div/div/div/form/button/span"
        Then I wait for "Sorry, something went wrong"
        Then I fill selector "#forgot-password > div > div > div > form > div > input" with "test@gmail.com"
        And I click on the element with xpath "//*[@id='forgot-password']/div/div/div/form/button/span"
        # Incomplete (doesn't work on staging)

    @sign-in
    @javascript
    Scenario: Sign In - Register instead
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(1) > a"
        Then I wait for "Sign into your Specfox Account"
        Then I click on the element with css selector "#sign-in > div > div > div > div > div.colLeft > p:nth-child(3) > a > strong"
        Then I wait for "Sign up for your Free Specfox Account"
        Then I should see "Sign up for your Free Specfox Account" appear

    @sign-in
    @javascript
    Scenario: Sign In - Successful
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(1) > a"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear

    @sign-up
    @javascript
    Scenario: Sign Up - Wrong email format
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN UP"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(2) > a"
        Then I wait for "Sign up for your Free Specfox Account"
        Then I fill in "first_name" with "Test First name"
        Then I fill in "last_name" with "Test Last name"
        Then I fill in "company_name" with "Test Company name"
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(3) > input" with "test"
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > div:nth-child(1) > input" with "testtest"
        Then I fill in "password_confirmation" with "testtest"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for 5 seconds
        And I should be on homepage
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > input" with "test@"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for 5 seconds
        And I should be on homepage
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > input" with "test@gmail.com"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "The email has already been taken"
        And I should see "The email has already been taken" appear
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > input" with a random mail
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "Get started by creating your first project!"

    @sign-up
    @javascript
    Scenario: Sign Up - Invalid Password
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN UP"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(2) > a"
        Then I wait for "Sign up for your Free Specfox Account"
        Then I fill in "first_name" with "Test First name"
        Then I fill in "last_name" with "Test Last name"
        Then I fill in "company_name" with "Test Company name"
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(3) > input" with a random mail
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > div:nth-child(1) > input" with "correct1"
        Then I fill in "password_confirmation" with "incorrect1"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "Passwords don't match"
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(5) > div:nth-child(1) > input" with "under"
        Then I fill in "password_confirmation" with "under"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "The password must be at least 8 characters"
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(5) > div:nth-child(1) > input" with "testtest"
        Then I fill in "password_confirmation" with "testtest"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "Get started by creating your first project!"

    @sign-up
    @javascript
    Scenario: Sign Up - Successful
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN UP"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(2) > a"
        Then I wait for "Sign up for your Free Specfox Account"
        Then I fill in "first_name" with a random name
        Then I fill in "last_name" with a random surname
        Then I fill in "company_name" with a random name
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(3) > input" with a random mail
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > div:nth-child(1) > input" with "testtest"
        Then I fill in "password_confirmation" with "testtest"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "Get started by creating your first project!"

    @user-actions
    @javascript
    Scenario: Create new project
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN UP"
        Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(2) > a"
        Then I wait for "Sign up for your Free Specfox Account"
        Then I fill in "first_name" with a random name
        Then I fill in "last_name" with a random surname
        Then I fill in "company_name" with a random name
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(3) > input" with a random mail
        Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > div:nth-child(1) > input" with "testtest"
        Then I fill in "password_confirmation" with "testtest"
        Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
        Then I wait for "Get started by creating your first project!"
        Then I press "Create new project"
        Then I wait for 2 seconds
        Then I fill in "project_title" with a random name
        Then I press "Create project"
        Then I wait for "Upload screens"

   # @user-actions
   # @javascript
   # Scenario: Add new screens
   #     Given I am on homepage
   #     Then I resize the browser
   #     And I should see "SIGN UP"
   #     Then I click on the element with css selector "#app > header > div > div.navigation > nav.account > ul > li:nth-child(2) > a"
   #     Then I wait for "Sign up for your Free Specfox Account"
   #     Then I fill in "first_name" with a random name
   #     Then I fill in "last_name" with a random surname
   #     Then I fill in "company_name" with a random name
   #     Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(3) > input" with a random mail
   #     Then I fill selector "#sign-up > div > div > div > div > div.colRight > form > div:nth-child(4) > div:nth-child(1) > input" with "testtest"
   #     Then I fill in "password_confirmation" with "testtest"
   #     Then I click on the element with css selector "#sign-up > div > div > div > div > div.colRight > form > button"
   #     Then I wait for "Get started by creating your first project!"
   #     Then I press "Create new project"
   #     Then I wait for 2 seconds
   #     Then I fill in "project_title" with a random name
   #     Then I press "Create project"
   #     Then I wait for "Upload screens"
   #     Then I attach the file "HDD/Users/maximlazar/Desktop/Test" to "Upload screens"


    @user-actions
    @javascript
    Scenario: Edit screens
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "body.template-homepage header.fixed-header a.btn[data-toggle='modal'][data-target='#sign-in']"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear
        Then I click on the element with css selector "#content-wrapper > div.projects-wrapper > div > div:nth-child(2) > div > div > div > div > div.images > div.overlay > a"
        Then I wait for "Description Pages" to appear
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-wrapper > div > div > div.clearfix.attachments > div > div > span > div:nth-child(1) > div > div.images > div.overlay > a"
        Then I wait for "Add text block"
        Then I click on the element with css selector "#page > div > div.sidebar-container > div > button"
        And I wait for "Type description here"
        Then I fill selector "#sidebar > div > span > div > div > div" with a random text
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(1) > div > a"
        And I wait for 1 seconds
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(1) > div > div > ul > li:nth-child(5)"
        And I wait for 1 seconds
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(1) > div > a"
        And I wait for 1 seconds
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(4) > a"
        And I wait for 3 seconds
        Then grab a screenshot
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(3) > a"
        And I wait for 3 seconds
        Then grab a screenshot
       # And I should be on "/app/projects/0620242e-ed5e-4d3f-a9d5-15909ceac506/screens/86426f9e-60c0-4df3-9179-46ccb491eea4/edit"
       # Then I focus on selector "#sidebar > div"
       # Then grab a screenshot
       # Then I click on the element with css selector "#sidebar > div > span > div:nth-child(1) > span.delete"
       # And I wait for "Delete"
       # Then I click on the element with css selector "#sidebar > div > span > div:nth-child(1) > div.deleteConfirmWrapper > a.deleteConfirm"
        Then I click on the element with css selector "#content-wrapper > div > header > div > div.pull-right > ul > li:nth-child(5) > a"
        And I wait for "Description Pages" to appear
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-wrapper > div > div > div.clearfix.attachments > div > div > span > div:nth-child(4) > div > div.images > div.overlay > div > div.right-actions > button"
        Then I wait for 1 seconds
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-wrapper > div > div > div.clearfix.attachments > div > div > span > div:nth-child(4) > div > div.images > div.overlay > div.singleDeleteConfirm > button.yes"
        Then grab a screenshot

    @user-actions
    @javascript
    Scenario: Description Pages
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "body.template-homepage header.fixed-header a.btn[data-toggle='modal'][data-target='#sign-in']"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear
        Then I click on the element with css selector "#content-wrapper > div.projects-wrapper > div > div:nth-child(2) > div > div > div > div > div.images > div.overlay > a"
        Then I wait for "Description Pages" to appear
        Then I click on the element with css selector "#content-wrapper > div > main > div > div:nth-child(2)"
        Then I wait for "Page 1"
        Then I click on the element with css selector "#bttn-wrapper-1 > button:nth-child(10)"
        Then I wait for "Create Page"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-description > div > a"
        Then I wait for "Page 1" to appear
        Then I fill selector "#content-wrapper > div > main > div > div.view-project-description > div > div > div.tab-content > div > div > div > div > div.froala-wrapper.f-basic" with a random text
          #selector should have" >div"
        Then I click on the element with css selector "#bttn-wrapper-2 > button:nth-child(1) > i"
        Then I fill selector "#content-wrapper > div > main > div > div.view-project-description > div > div > div.tab-content > div > div > div > div > div.froala-wrapper.f-basic" with a random text
          #selector should have" >div"
        Then I click on the element with css selector "#bttn-wrapper-2 > button:nth-child(2) > i"
        Then I fill selector "#content-wrapper > div > main > div > div.view-project-description > div > div > div.tab-content > div > div > div > div > div.froala-wrapper.f-basic" with a random text
          #selector should have" >div"
        Then I click on the element with css selector "#bttn-wrapper-2 > button:nth-child(3) > i"
        Then I fill selector "#content-wrapper > div > main > div > div.view-project-description > div > div > div.tab-content > div > div > div > div > div.froala-wrapper.f-basic" with a random text
          #selector should have" >div"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-description > div > div > div.tabs > div > div.tab-button.add-new-page > a"
        And I wait for "Page 2"
        Then I click on the element with css selector "#bttn-wrapper-3 > button:nth-child(10) > i"
        Then I wait for 2 seconds
        Then I should not see "Page 2"

    @user-actions
    @javascript
    Scenario: Project Settings
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "body.template-homepage header.fixed-header a.btn[data-toggle='modal'][data-target='#sign-in']"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear
        Then I click on the element with css selector "#content-wrapper > div.projects-wrapper > div > div:nth-child(2) > div > div > div > div > div.images > div.overlay > a"
        Then I wait for "Project Settings" to appear
        Then I click on the element with css selector "#content-wrapper > div > main > div > div:nth-child(3)"
        Then I wait for "Custom Cover image" to appear
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(2) > div.pull-right > div > div.coverImageSwitcher > label:nth-child(5)"
        Then I wait for "Main image" to appear
      # Then I attach the file "dummy.jpg" to selector field "#project_main_image"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(4) > div.pull-right > div > p > span > label"
        Then I wait for 1 seconds
        And I should not see "Define color labels"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(4) > div.pull-right > div > p > span > label"
        Then I wait for 1 seconds
        And I should see "Define color labels"
        Then I fill selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(4) > div.pull-right > div > div > div > div:nth-child(1) > input" with a random text
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(6) > div.pull-right > div > div.pdfColorWrapper > label:nth-child(33)"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(6) > div.pull-right > div > div:nth-child(2) > span.switch-toggle > label"
        Then I wait for 1 seconds
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(6) > div.pull-right > div > div:nth-child(2) > span.switch-toggle > label"
        Then I click on the element with css selector "#content-wrapper > div > main > div > div.view-project-settings.projectSettingsContent > div > form > div:nth-child(7) > input"

    @user-actions
    @javascript
    Scenario: Download PDF
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "body.template-homepage header.fixed-header a.btn[data-toggle='modal'][data-target='#sign-in']"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear
        Then I click on the element with css selector "#content-wrapper > div.projects-wrapper > div > div:nth-child(2) > div > div > div > div > div.images > div.overlay > a"
        Then I wait for "Description Pages" to appear
        Then I click on the element with css selector "#content-wrapper > div > div.view-project-top-bar > div > div.pull-right.text-right > a"
        Then I wait for 10 seconds
        Then I click on the element with css selector "#app > header > div > div.pull-right > a"

    @user-actions
    @javascript
    Scenario: Preview PDF
        Given I am on homepage
        Then I resize the browser
        And I should see "SIGN IN"
        Then I click on the element with css selector "body.template-homepage header.fixed-header a.btn[data-toggle='modal'][data-target='#sign-in']"
        Then I wait for "Sign into your Specfox Account"
        Then I fill in "email" with "test@gmail.com"
        And I fill in "password" with "testtest"
        Then I press "Sign in"
        Then I wait for "Create new project" to appear
        Then I click on the element with css selector "#content-wrapper > div.projects-wrapper > div > div:nth-child(2) > div > div > div > div > div.images > div.overlay > a"
        Then I wait for "Description Pages" to appear
        Then I click on the element with css selector "#content-wrapper > div > div.view-project-top-bar > div > div.pull-right.text-right > a"
        Then I wait for 25 seconds
        Given I have pdf located at "/app/projects/0620242e-ed5e-4d3f-a9d5-15909ceac506-2018-09-04_105800.pdf"
