alias Lineup.Repo
alias Lineup.Todos.Group
alias Lineup.Todos

workout = Repo.insert!(%Group{name: "Workout"})

{:ok, %{task: carry_gym_bag}} =
  Todos.create_task(%{"name" => "Carry gym bag", "group_id" => workout.id})

Todos.create_task(%{
  "name" => "Go to gym",
  "group_id" => workout.id,
  "depended_task_ids" => [carry_gym_bag.id]
})

offday = Repo.insert!(%Group{name: "Offday"})

{:ok, %{task: purchase}} =
  Todos.create_task(%{
    "name" => "Purchase",
    "description" => "Some groceries",
    "group_id" => offday.id
  })

Todos.create_task(%{
  "name" => "Wash cloths",
  "group_id" => offday.id,
  "depended_task_ids" => [purchase.id]
})

Todos.create_task(%{
  "name" => "Clean floor",
  "group_id" => offday.id,
  "depended_task_ids" => [purchase.id]
})

Todos.create_task(%{
  "name" => "Make dinner",
  "group_id" => offday.id,
  "depended_task_ids" => [purchase.id]
})

art = Repo.insert!(%Group{name: "Art"})

{:ok, %{task: buy_paper}} = Todos.create_task(%{"name" => "Buy paper", "group_id" => art.id})
{:ok, %{task: buy_glue}} = Todos.create_task(%{"name" => "Buy glue", "group_id" => art.id})

Todos.create_task(%{
  "name" => "Make poster",
  "group_id" => art.id,
  "depended_task_ids" => [buy_paper.id, buy_glue.id]
})
