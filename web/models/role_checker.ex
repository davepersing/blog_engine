defmodule BlogEngine.RoleChecker do
    alias BlogEngine.Repo
    alias BlogEngine.Role

    def is_admin?(nil) do
        false
    end

    def is_admin?(user) do
        (role = Repo.get(Role, user.role_id)) && role.admin
    end
end
