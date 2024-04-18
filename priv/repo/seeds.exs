alias Lineup.Repo
alias Lineup.Todos.Group
alias Lineup.Todos.Task

workout = Repo.insert!(%Group{name: "workout"})

carry_gym_bag =
  %Task{}
  |> Task.changeset(%{"name" => "Carry gym bag", "group_id" => workout.id})
  |> Repo.insert!()

%Task{}
|> Task.changeset(%{
  "name" => "Go to gym",
  "group_id" => workout.id,
  "depended_task_id" => carry_gym_bag.id
})
|> Repo.insert!()

offday = Repo.insert!(%Group{name: "Offday"})

purchase =
  %Task{}
  |> Task.changeset(%{
    "name" => "Purchase",
    "description" => "Some groceries",
    "group_id" => offday.id
  })
  |> Repo.insert!()

%Task{}
|> Task.changeset(%{
  "name" => "Wash cloths",
  "group_id" => offday.id,
  "depended_task_id" => purchase.id
})
|> Repo.insert!()

%Task{}
|> Task.changeset(%{
  "name" => "Clean floor",
  "group_id" => offday.id,
  "depended_task_id" => purchase.id
})
|> Repo.insert!()

%Task{}
|> Task.changeset(%{
  "name" => "Make dinner",
  "group_id" => offday.id,
  "depended_task_id" => purchase.id
})
|> Repo.insert!()
