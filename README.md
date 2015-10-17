TemporaryEnv
============

[![Build Status](https://travis-ci.org/lpil/temporary-env.svg?branch=master)](https://travis-ci.org/lpil/temporary-env)
[![Hex downloads](https://img.shields.io/hexpm/dt/temporary-env.svg "Hex downloads")](https://hex.pm/packages/temporary-env)
[![Hex version](https://img.shields.io/hexpm/v/temporary-env.svg "Hex version")](https://hex.pm/packages/temporary-env)


Temporarily set an Application environment value within a block, for when you
need to test behaviour that depends on Application environment values.

```elixir
TemporaryEnv.set :my_app, greeting: "Hello!" do
  # :greeting for :my_app is now "Hello!"
end
# :greeting for :my_app is back to its original value
```

This *does* modify global state, so do not use it in an async situation.

## Usage

Add it as a mix dependancy.

```elixir
# mix.exs
def deps do
  [
    {:temporary_env, github: "lpil/temporary-env", only: :test},
  ]
end
```

Install this new dependancy.

```
mix deps.get
```

Use it in your tests, but only in cases with async set to false.

```elixir
# test/some_example_test.exs
defmodule SomeExampleTest do
  use ExUnit, async: false
  use TemporaryEnv

  test "TemporaryEnv works" do
    TemporaryEnv.set :my_app, greeting: "Hello, world!" do
      value = Application.get_env :my_app, :greeting
      assert value == "Hello, world!"
    end
    value = Application.get_env :my_app, :greeting
    assert value == nil
  end
end
```


# LICENCE

```
TemporaryEnv
Copyright © 2015 Louis Pilfold - MIT Licence

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
