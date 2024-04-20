# Lineup

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### To run Dialyzer

Run `mix dialyzer`  

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Wonderschool Coding Challenge

## Introduction

Thanks for your interest in joining the Wonderschool engineering team! Before we proceed with more
formal interviews, we ask that all candidates submit a coding challenge. The coding challenge is
a foundational piece of our process and it's referenced later in our process during the technical
interviews.

For an experienced full stack developer, the coding challenge should not take longer than **2-4 hours** to
complete.

If at any point you have questions concerning the coding challenge and/or interview process, please
do not hesitate to email engineering@wonderschool.com.

## Coding Challenge

The coding challenge revolves around building a task list. Tasks belong to groups and can have
dependencies on one another (i.e. if task X depends on task Y, task X cannot be completed until
task Y is completed). The challenge includes 3 components:

- Build Phoenix LiveView based UI
- Design database schemas to store todo's using Ecto

### Build LiveView based UI

The UI consists of 2 screens:

- **Overview**: Displays a list of all the groups along with their completion status. Clicking on
  a group should render the detail screen.

- **Detail**: Displays a list of all the tasks in the selected group and allows the user to toggle
  the completion status of unlocked tasks.

The screens should look like this:

![screen design](https://user-images.githubusercontent.com/314351/56453206-d1ec2580-62f3-11e9-83d7-67aff2e1deef.png)

SVG assets for the icons used in the design can be found in the _public/_ directory.

Some things to keep in mind:

- Locked tasks cannot have their completion status toggled
- Tasks remain locked until all of their dependencies have been completed
- Marking a task as incomplete should lock the corresponding tasks for which it is a dependency
- Your implementation should resemble the above design
- **Please don't introduce any new dependencies**, you should have everything you need to complete
  the challenge
- We value well structured code that follows best practices

### Design and Build Database Schema

Design a schema to store the task list data. You should use Ecto migrations to create
the tables needed. The schema should define all tables, columns, and constraints needed
to store the task list data.

### Implement schema modules and context

Implement the corresponding schema modules for each new table designed in the previous step (structs or emedded schemas are permittable, as well, depending on your database implementation). Typespecs with Dialyzer are definitely favored.

Write a context that manages your todo's and interacts with the repo. Please be wary of naming and directory structure conventions.

### Implement LiveView pages and components for the frontend

Build the UI screens described above using phoenix live views/components.

### _Extra Credit_

Integrate React with LiveView to implement smaller components in the page (e.g. the checkboxes)

## Getting Started

### Setup

Depending on your environment you might first have to install all dependencies to run the elixir backend. Please see the [phoenix getting started documentation](https://hexdocs.pm/phoenix/installation.html) for more details. Once you have Elixir/Phoenix/Postgres installed you can setup a new LiveView project by following the [phoenix live view installation](https://hexdocs.pm/phoenix_live_view/installation.html) guide.
Once you have all needed dependencies installed start the server by standing in the _/backend_ folder and run:

```
mix phx.server
```

At this point, the app should be running in development mode and any local modifications you make
will be automatically detected and result in the app to reload.

## Submission

To submit your coding challenge, commit all your changes to the `master` branch and run the
following commands:

```
# Make sure all changes were committed
git diff-index --quiet HEAD -- || echo 'You have uncommitted changes!'

# Create bundle to submit
git bundle create ws-coding-challenge.bundle HEAD master
```

Email the generated _coding-challenge.bundle_ file to engineering@wonderschool.com. We do our
best to review and respond to submissions within 1-2 business days.

Thanks for taking the time to do this coding challenge and here's hoping we talk soon!

## Things to note

1. Typespecs for Elixir code are appreciated
2. Testing is favored if time permits. We care more about more clean architecture than 100% test coverage so if you're tight on time, focus there.
3. Please avoid using Phoenix generators for context functionality; we'd rather see your code and your patterns :)
4. Have fun with it! We understand that coding challenges are a pain, but we really appreciate your participation in this process!
5. If you have any you any questions or special circumstances, we are more than willing to work with you on having the best possible interview process.
