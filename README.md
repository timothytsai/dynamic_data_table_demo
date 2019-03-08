# Dynamic DataTable Demo
Let's say you have a very wide dataset and you want to make this data available
for display in a web app.  With a very wide table, the user will have to scroll
across the page, potentially losing track of the information on the far left, 
which is typically where indexing columns are positions (i.e., record ID).

This demo is an R Shiny web app that illustrates how to create a DataTable
(from the DT library) with columns that can be selected dynamically from user
input.

# Setup
This app uses the `shiny`, `dplyr`, and `DT` R packages.  Use 
`install.packages(c("shiny", "dplyr", "DT"))` to install.

# Walkthrough
We'll go over the basic structure of the app and how it works.

## Structure
The app is structured using the `app.R` format, where the app is contained in a
single file.  The UI is defined with a code block:

```
ui <- fluidPage(
...
)
```

And the server code with:
```
server <- function(input, output){
...
}
```

Finally, there is a call to `shinyApp` which creates the the app object and
returns it:
```
shinyApp(ui, server)
```

## UI
We are using the `fluidPage()` layout with a title panel (`titlePanel()`) and a
main panel (`mainPanel()`).

In the UI code block, you will see three function calls:

* `h3()` - a shiny HTML helper function which tags text within it as a
third-level heading
* `uiOutput()` - renders a UI element created by `renderUI()` in the server code
* `dataTableOutput()` - creates a container for our DataTable which is created
in the server code by `renderDataTable()`

## Server
In the server code, we are first creating some objects (`dynamic_select_preset`
and `data_colnames`) to make our code a little more flexible.  If we want to
change our presets, it's easier to change these objects than to find each
occurrence and change them one by one. We also save our data set 
(the `dplyr::starwars` dataset) to its own object.

To create the selection field UI element, we call the `selectizeInput()`
function wrapped in `renderUI()`, setting the available choices as the column
names of our dataset and the selected columns as the presets we defined earlier.

Because these parameters are their own objects rather than being hard coded,
it's easier change them or have them be passed from another function or 
element of the app.

Finally, we render our `DataTable` with the `renderDataTable()` function.
Since the result of this function call depends on a reactive element -
`dynamic_select`, we need to use the `req()` function to make sure that value is
available before proceeding with the rest of the function.

Next, we use the `dynamic_select` input to index the columns we want to appear
in the table and, by the negation operation, the columns we don't want to
appear.  These are declared explicitly so that we can work with these values
later, if desired (e.g., formatting column names).

We subtract 1 from the index vector `not_visible_targets` because with
`rownames = FALSE`, the DataTable will be zero-indexed.

The call to create the datatable is relatively straightforward.  The piece of
this code which hides the is the `columnDefs`, setting `visible = FALSE` with
the targets of `not_visible_targets` which we saved before.