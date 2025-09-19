# RUN COMMAND
  * `mix setup` install and setup dependencies
  *  `mix phx.server` run application
  *  `localhost:4000` browser endpoint

# CREATE API
  * mix phx.gen.json Domain UserToken user_token id:string token:string

# CREATE DB SCHEMA
  * mix phx.gen.schema Shop shop id:string
  * mix phx.gen.schema Token token id:string

# CREATE PROJECT COMMAND
 * mix phx.new 
    * --no-assets - do not generate the assets folder
    * --no-ecto - do not generate Ecto files
    * --no-html - do not generate HTML views
    * --no-gettext - do not generate gettext files
    * --no-dashboard - do not include Phoenix.LiveDashboard
    * --no-mailer - do not generate Swoosh mailer files

# Swager
 - http://localhost:3002/swagger
