defmodule TemporaryEnv do
  @moduledoc """
  Temporarily set Application environment variables.

  Quite handy for testing, but remember to set `async: false` for tests suites
  it is used in.

  """

  defmodule RemovedAPI do
    defexception [:message]
  end


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

  @spec put(atom, atom, any, [{:do, any}]) :: any
  @doc """
  Temporarily set an Application environment value within a block.

      TemporaryEnv.put :my_app, :greeting, "Hello!" do
        # :greeting for :my_app is now "Hello!"
      end
      # :greeting for :my_app is back to its original value

  This *does* modify global state, so do not use it in an async situation.

  """
  defmacro put(app, key, value, do: block) do
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

  @doc false
  defmacro set(app, [{key, value}], do: _block) do
    quote do
      raise TemporaryEnv.RemovedAPI, """


      The function TemporaryEnv.set/3 has been removed in favour of
      TemporaryEnv.put/4. Please update your code like so:

          TemporaryEnv.set :#{unquote(app)}, #{unquote(key)}: #{unquote(inspect(value))} do
            # body...
          end

      becomes...

          TemporaryEnv.put :#{unquote(app)}, :#{unquote(key)}, #{unquote(inspect(value))} do
            # body...
          end

      Note the key and value to be set are not a keyword pair, but
      instead two arguments, one after the other. This is to match
      `Application.put_env/4` and `System.put_env/2`.

      """
    end
  end

  @spec set(atom, atom, [{:do, any}]) :: any
  @doc """
  Temporarily unset an Application environment value within a block.

      TemporaryEnv.delete :my_app, :greeting do
        # :greeting for :my_app now has no value
      end
      # :greeting for :my_app is back to its original value

  This *does* modify global state, so do not use it in an async situation.

  """
  defmacro delete(app, key, do: block) when key |> is_atom do
    quote do
      # Get original state
      unquote(app)
      |> Application.get_env( unquote(key), unquote(@default) )
      |> case do
        # when the value was previously unset
        unquote(@default) ->
          unquote(block)

        # when the value was previously set
        val ->
          try do
            Application.delete_env unquote(app), unquote(key)
            unquote(block)
          after
            Application.put_env unquote(app), unquote(key), val
          end
      end
    end
  end
end
