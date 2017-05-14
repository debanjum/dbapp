Publication Application
=======================


Commands
--------
- Mode: None
  1. `login <id>`

     display's custom info based on type of user (author, reviewer, editor) logging in

- Mode: Editor
  1. `status [issue#]`

     show manuscripts assigned to logged in editor
     if (optional argument) issue# passed
     show manuscripts in issue#

  2. `assign <manu#> <reviewer_id>`

     assigns manuscript to reviewer if
     1. manuscript belongs to logged in editor
     2. id of type = reviewer,
     3. reviewer and manuscript ri_codes match

  3. `reject <manu#>`

     update manuscript status to rejected and update timestamp, if
     1. manuscript belongs to logged in editor
     2. reviewed by all manuscript reviewers

  4. `accept <manu#>`

     update manuscript status to accepted and update timestamp, if
     1. manuscript belongs to logged in editor
     2. reviewed by all manuscript reviewers

  5. `typeset <manu#> <pp>`

     update manuscript status to typeset, update timestamp, num_pages, if
     1. manuscript belongs to logged in editor
     2. reviewed by all manuscript reviewers

  6. `schedule <manu#>`

     update manuscript status to accepted and update timestamp, if
     1. manuscript belongs to logged in editor
     2. reviewed by all manuscript reviewers

  7. `publish <issue_vol#> <issue_year>`

     update status of issue and all manuscripts in issue

  8. `createissue <issue_vol> <issue_year> <issue_period> <issue_title>`

     create an issue in issue table
     ensure issue_period between 0 and 4 for this quaterly publication
  9. `logout`
     log out of current user's account


- Mode: Author
  1. `status [issue#]`

     show manuscripts for which the logged in author is the primary author

  2. `submit <title> <Affiliation> <RICode> [author2] [author3] [author4] ... <filename>`

     assign editor to the submitted manuscript
     create manuscript in table with status set to submitted
     update primary author affiliation
     insert authors with their ranks into manuscript_author table only if they already exist as authors in persons table

  3. `retract <manuscript_id>`

     delete manuscript, and its associated entries in manuscript_author, manuscript_reviewer tables only if
     retraction issued by manuscripts primary author

  4. `logout`
     log out of current user's account

- Mode: Reviewer
  1. `status [issue#]`

     show manuscripts assigned to logged in editor
     if (optional argument) issue# passed
     show manuscripts in issue#

  2. `accept <manuscript_id>`
  3. `reject <manuscript_id>`
  4. `resign`
  5. `logout`
     log out of current user's account

- Mode: Any
  1. register

     register person with their various attributes into the person's table. only a registered person can log into publication system

     Author:   `register author <fname> <lname> <email> <address>`


     Editor:   `register editor <fname> <lname>`


     Reviewer: `register reviewer <fname> <lname> <ri_code1> [ri_code2] [ri_code3]`

  2. `execute <sql_statement>`

     execute is a developer helper function that allows executing raw SQL statements on the connected sql server

  3. `display <sql_statement>`

     display is a developer helper function that allows executing SELECT SQL statements and rendering the results on the command line
  4. `help <command>`

     shows a list of commands available in the current mode of the application
     if <command> argument passed, shows the help for the corresponding command if it exists

  5. `exit`, `quit`

     disconnects from the publication service command line application
