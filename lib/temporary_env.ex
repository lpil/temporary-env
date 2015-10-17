defmodule TemporaryEnv do
  @moduledoc """
  Temporarily set Application environment variables.

  Quite handy for testing, but remember to set `async: false` for tests suites
  it is used in.
  """

  @default :temporary_env_default_value_for_unset_var

  @doc false
  defmacro __using__(_) do
    quote do
      require TemporaryEnv
      test "TemporaryEnv test case async status", context do
        refute context.async, """
        TemporaryEnv cannot be used in async tests.

        To make this test case synchronous, modify your use of
        ExUnit.Case like so:

            use ExUnit.Case, async: false
        """
      end
    end
  end

  @spec set(atom, [{atom, any}], [{:do, any}]) :: any
  @doc """
  Temporarily set an Application environment value within a block.

      TemporaryEnv.set :my_app, greeting: "Hello!" do
        # :greeting for :my_app is now "Hello"
      end
      # :greeting for :my_app is back to its original value

  This *does* modify global state, so do not use it in an async situation.
  """
  defmacro set(app, [{key, value}], do: block) do
    quote do
      # Get original state
      temporary_env_original_value = Application.get_env(
        unquote(app), unquote(key), unquote(@default)
      )
      try do
        # Set temporary state
        Application.put_env unquote(app), unquote(key), unquote(value)
        unquote(block)
      after
        # Restore original state
        case temporary_env_original_value do
          # when the value was previously unset
          unquote(@default) ->
            Application.delete_env( unquote(app), unquote(key) )

          # when the value was previously set
          _ ->
            Application.put_env(
              unquote(app), unquote(key), temporary_env_original_value
            )
        end
      end
    end
  end
end
