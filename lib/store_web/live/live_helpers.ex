defmodule StoreWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.product_index_path(@socket, :index)}>
        <.live_component
          module={StoreWeb.ProductLive.FormComponent}
          id={@product.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.product_index_path(@socket, :index)}
          product: @product
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)
    assigns = assign_new(assigns, :hide_close_button, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in hidden px-2" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale max-w-md rounded-xl"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_redirect("✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          ) %>
        <% else %>
          <%= if not @hide_close_button do %>
            <button
              id="close"
              type="button"
              phx-click={hide_modal()}
              class="top-3 right-2.5 float-right ml-auto inline-flex items-center rounded-lg bg-transparent p-1.5 text-sm hover:bg-gray-200 hover:text-gray-900"
              data-modal-hide="popup-modal"
            >
              <svg
                aria-hidden="true"
                class="h-5 w-5"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fill-rule="evenodd"
                  d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                >
                </path>
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          <% end %>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
    |> JS.remove_class("overflow-hidden", to: "#root")
  end

  def show_modal(js \\ %JS{}) do
    js
    |> JS.show(to: "#modal", transition: "fade-in")
    |> JS.show(to: "#modal-content", transition: "fade-in-scale")
    |> JS.add_class("overflow-hidden", to: "#root")
  end
end
