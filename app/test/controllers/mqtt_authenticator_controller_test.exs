defmodule Sense.MqttAuthenticatorControllerTest do
  use Sense.ConnCase
  import Sense.Factory

  @auth_users_attrs %{username: "num0ne", password: "goodPassw0rd", clientid: "1", topic: "", acc: ""}
  @auth_superusers_attrs %{username: "JohnDoEx", password: "", clientid: "1", topic: "", acc: ""}

  describe "MqttAuthenticatorController#user" do
    test "return 200 for an authorized", %{conn: conn} do
      insert(:user, %{username: "num0ne", encrypted_password: "goodPassw0rd"})
      conn = post conn, mqtt_authenticator_path(conn, :user),  @auth_users_attrs
      assert conn.status == 200
    end

    test "not return a 200 for a invalid tuple user/password", %{conn: conn} do
      insert(:user, %{username: "num0ne", password: "badPassw0rd"})
      conn = post conn, mqtt_authenticator_path(conn, :user), @auth_users_attrs
      refute conn.status == 200
    end

    test "not return a 200 for a no existing user", %{conn: conn} do
      conn = post conn, mqtt_authenticator_path(conn, :user), @auth_users_attrs
      refute conn.status == 200
    end
  end

  describe "MqttAuthenticatorController#superuser" do
    test "return 200 for an authorized", %{conn: conn} do
      conn = post conn, mqtt_authenticator_path(conn, :superuser),  @auth_superusers_attrs
      assert conn.status == 200
    end

    test "not return a 200 for a invalid tuple user/password", %{conn: conn} do
      conn = post conn, mqtt_authenticator_path(conn, :superuser), %{username: "other", password: "case"}
      refute conn.status == 200
    end
  end
end
