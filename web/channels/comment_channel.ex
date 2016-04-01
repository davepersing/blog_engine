defmodule BlogEngine.CommentChannel do
  use BlogEngine.Web, :channel

  alias BlogEngine.CommentHelper

  def join("comments:" <> post_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("CREATED_COMMENT", payload, socket) do
    case CommentHelper.create(payload, socket) do
      {:ok, comment} ->
        IO.puts "CREATED_COMMENT: #{inspect comment}"
        broadcast socket, "CREATED_COMMENT", Map.merge(payload, %{insertedAt: comment.inserted_at, commentId: comment.id, approved: comment.approved})
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_in("APPROVED_COMMENT", payload, socket) do
    case CommentHelper.approve(payload, socket) do
      {:ok, comment} ->
        IO.puts "Approved comment: #{inspect payload}"
        payload = Map.merge(payload, %{insertedAt: comment.inserted_at, commentId: comment.id})
        broadcast socket, "APPROVED_COMMENT", payload
        {:noreply, socket}
      {:error, _} ->
        IO.puts "Error approving comment"
        {:noreply, socket}
    end
  end

  def handle_in("DELETED_COMMENT", payload, socket) do
    case CommentHelper.delete(payload, socket) do
      {:ok, _} ->
        broadcast socket, "DELETED_COMMENT", payload
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
