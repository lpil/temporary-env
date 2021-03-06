defmodule TemporaryEnv.SetTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  test "deprecated set/3" do
    assert_raise TemporaryEnv.RemovedAPI, fn->
      TemporaryEnv.set :tmp_test, foo: 1 do
        assert Application.get_env(:tmp_test, :foo) == 1
      end
    end
  end


  describe "put/4" do
    test "sets the value inside the block" do
      TemporaryEnv.put :tmp_test, :foo, 1 do
        assert Application.get_env(:tmp_test, :foo) == 1
      end
    end

    test "resets an already set value" do
      Application.put_env(:tmp_test, :bar, "hello")
      TemporaryEnv.put :tmp_test, :bar, 2 do
        assert Application.get_env(:tmp_test, :bar) == 2
      end
      assert Application.get_env(:tmp_test, :bar) == "hello"
    end

    test "resets an unset value" do
      Application.delete_env(:tmp_test, :baz)
      TemporaryEnv.put :tmp_test, :baz, 3 do
        assert Application.get_env(:tmp_test, :baz) == 3
      end
      assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
    end

    test "resets an already set value when an exception is raised" do
      try do
        Application.put_env(:tmp_test, :bar, "hello")
        TemporaryEnv.put :tmp_test, :bar, 2 do
          raise SyntaxError
        end
      rescue
        SyntaxError -> nil
      end
      assert Application.get_env(:tmp_test, :bar) == "hello"
    end

    test "resets an unset value when an exception is raised" do
      try do
        Application.delete_env(:tmp_test, :baz)
        TemporaryEnv.put :tmp_test, :baz, 3 do
          raise SyntaxError
        end
      rescue
        SyntaxError -> nil
      end
      assert Application.get_env(:tmp_test, :baz, :some_default) == :some_default
    end
  end
end
