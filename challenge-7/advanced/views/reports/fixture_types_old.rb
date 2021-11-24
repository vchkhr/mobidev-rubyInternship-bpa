<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <title>Fixture Type Count Report</title>
  </head>

  <body style="padding: 1em">
    <div class="d-flex" style="height: 100px;">
      <div class="d-flex" style="width: 200px; border: 1px solid black; align-items: center; justify-content: center;">LOGO</div>
      <div class="flex-fill h-100">
        <div class="d-flex h-100" style=" align-items: center; justify-content: center;">
          <h1>
            <% if @office.nil? %>
              <span>Fixture Type Count Report</span>
            <% elsif @types.empty? %>
              <a href="/reports/offices/fixture_types">Fixture Type Count Report</a>
            <% else %>
              <a href="/reports/offices/fixture_types">Fixture Type Count Report</a> / <%= @office_name %>
            <% end %>
          </h1>
        </div>
       </div>
    </div>

    <div>
      <%= @types %>

      <% if @types.empty? %>
        <div class="alert alert-danger mt-3 mb-3 m-auto" role="alert" style="width: 500px;">
          There is no data for the office with this ID: <strong><%= @office %></strong>.
        </div>
      <% end %>
    </div>

    <p class="text-center"><a href="/">Go Home</a></p>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
  </body>
</html>
