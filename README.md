
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Logging best practices for R

The goal of logging in any language is to provide those who oversee the
running of your code with some insight into what it’s doing and when.
This will help them understand what actions your code is performing and
can help them diagnose any issues they might encounter.

## Repo contents

* `shiny-app` contains an interactive logging demo app

## What should I log?

There’s an argument to be made that *everything* should be logged or at
least made optionally log-able in a production application. Since
“production” is loaded word, we define that here as something that is
relied on by the business. It could be running in a multi-million dollar
data centre, or it could be running on an old desktop computer under
your desk, but if your organisation relies on that system, then it’s a
production system.

The other common factor with most production systems is that the code is
generally run unattended. This is in contrast to a large proportion of
data science work, where code is run interactively by the developer and
this means that ideas like logging can seem alien at first.

Imagine you’ve written a script in R. That script reads in some
configuration data, connects to a database, extracts some data,
transforms the data, loads the transformed data into a database, trains
a model against the transformed data and then publishes the new model.
If you (the developer of this script) run it and it errors out half way
through because it can’t connect to the database, you’ll be able to
quickly determine what went wrong. This is because you’re intimately
aware of what the script does and how, and you were probably watching
it’s progress when it broke.

Now, imagine you’ve given that script to someone to run on a schedule,
every night at 3am and the script must have run to completion before the
business day starts. Imagine the same error happens to this person. They
don’t know your code, they may not even know or care what it does, all
they care about is that it’s 3am and the thing that’s supposed to be
working isn’t. Their next call will likely be to you.

Next, imagine that it’s *you* that’s been given some code to run at 3am
every day, in a language you don’t really understand. Imagine it’s very
important that this code is run before the working day starts, but it’s
broken and you don’t know why. That’s not a great position to be in.

This is why we log.

Logging is about empathy for other people who may come into contact with
our code as well as our future selves. Log messages are often the first
point of contact with your code for people working in ops or support.
They may not know the langauge your code is written in, but it shouldn’t
matter. Log messages should provide a clear indication of the intent of
your application and wherever possible a clear indication of any error
states.

It’s essential that we communicate to others the intent of our
production applications so that they might be able to fix them in our
absence. I certainly don’t enjoy being woken up at 3am because an
application I wrote is having a trivial error but nobody can figure out
what’s going on. Log messages are your breadcrumb trail out of that
forest.

## First steps with logging

People will often put section headers in comments in their code. Things
like:

``` bash
# Load data from DB
```

If you replace these comments with INFO level log messages, you’ll have
made a great start.

Using the rlog package for R, that would look like this:

``` r
rlog::log_info("Load data from DB")
#> 2021-03-03 13:48:35 [INFO] Load data from DB
```

## Log levels

The most common log levels, in priority order, are as follows:

-   FATAL
-   ERROR
-   WARN
-   INFO
-   DEBUG
-   TRACE
