defmodule TemporaryEnv.DeleteTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  test "delete/3 removes the value inside the block" do
    Application.put_env :tmp_test, :foo, "hello"
    TemporaryEnv.delete :tmp_test, :foo do
      assert Application.get_env(:tmp_test, :foo, "1") == "1"
    end
  end

  test "delete/3 resets an already set value" do
    Application.put_env(:tmp_test, :bar, "hello")
    TemporaryEnv.delete :tmp_test, :bar do
      assert Application.get_env(:tmp_test, :bar, 2) == 2
    end
    assert Application.get_env(:tmp_test, :bar) == "hello"
  end

  test "delete/3 resets an unset value" do
    Application.delete_env(:tmp_test, :baz)
    TemporaryEnv.delete :tmp_test, :baz do
      assert Application.get_env(:tmp_test, :baz, 3) == 3
    end
    assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
  end

  test "delete/3 resets an already set value when an exception is raised" do
    try do
      Application.put_env(:tmp_test, :bar, "hello")
      TemporaryEnv.delete :tmp_test, :bar do
        raise SyntaxError
      end
    rescue
      SyntaxError -> nil
    end
    assert Application.get_env(:tmp_test, :bar) == "hello"
  end

  test "delete/3 resets an unset value when an exception is raised" do
    try do
      Application.delete_env(:tmp_test, :baz)
      TemporaryEnv.delete :tmp_test, :baz do
        raise SyntaxError
      end
    rescue
      SyntaxError -> nil
    end
    assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
  end
end
