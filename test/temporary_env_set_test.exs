defmodule TemporaryEnv.SetTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  test "set/3 sets the value inside the block" do
    TemporaryEnv.set :tmp_test, foo: 1 do
      assert Application.get_env(:tmp_test, :foo) == 1
    end
  end

  test "set/3 resets an already set value" do
    Application.put_env(:tmp_test, :bar, "hello")
    TemporaryEnv.set :tmp_test, bar: 2 do
      assert Application.get_env(:tmp_test, :bar) == 2
    end
    assert Application.get_env(:tmp_test, :bar) == "hello"
  end

  test "set/3 resets an unset value" do
    Application.delete_env(:tmp_test, :baz)
    TemporaryEnv.set :tmp_test, baz: 3 do
      assert Application.get_env(:tmp_test, :baz) == 3
    end
    assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
  end

  test "set/3 resets an already set value when an exception is raised" do
    try do
      Application.put_env(:tmp_test, :bar, "hello")
      TemporaryEnv.set :tmp_test, bar: 2 do
        raise SyntaxError
      end
    rescue
      SyntaxError -> nil
    end
    assert Application.get_env(:tmp_test, :bar) == "hello"
  end

  test "set/3 resets an unset value when an exception is raised" do
    try do
      Application.delete_env(:tmp_test, :baz)
      TemporaryEnv.set :tmp_test, baz: 3 do
        raise SyntaxError
      end
    rescue
      SyntaxError -> nil
    end
    assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
  end
end
