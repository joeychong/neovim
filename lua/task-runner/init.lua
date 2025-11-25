local M = {}

local function show_list(items, on_select)
  -- Create a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Put items into the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)

  -- make the buffer uneditable
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)

  -- Window size
  local width = 40
  local height = #items

  -- Popup options
  local opts = {
    relative = "editor",
    row = 5,
    col = 10,
    width = width,

    height = height,
    style = "minimal",
    border = "rounded",
  }


  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Mappings for 1–9
  for i = 1, math.min(#items, 9) do
    vim.keymap.set("n", tostring(i), function()

      -- callback to user handler
      if on_select then
        on_select(i, items[i])
      end
      -- close window
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true })
  end


  -- Close popup with <Esc>
  vim.keymap.set("n", "<Esc>", function()

    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })
end

local function read_json(filename)
  local cwd = vim.loop.cwd()           -- where you started nvim
  local path = cwd .. "/" .. filename

  --local file = assert(io.open(path, "r"))
  local file = io.open(path, "r")
  if not file then
    -- vim.notify("Cannot open " .. path, vim.log.levels.ERROR)
    return nil
  end

  local content = file:read("*a")
  file:close()

  return vim.json.decode(content)
end

local function popup_menu(items, on_select)

  local buf = vim.api.nvim_create_buf(false, true)

  -- write items
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)


  -- make menu read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)

  -- floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 40,
    height = #items,
    row = 5,
    col = 10,
    style = "minimal",
    border = "rounded",
  })

  ---------------------------------------------------------
  -- INTERNAL STATE
  ---------------------------------------------------------
  local current = 1

  -- highlight group
  vim.api.nvim_set_hl(0, "PopupMenuSel", { link = "Visual" })

  local function update_highlight()
    -- clear previous
    vim.api.nvim_buf_clear_namespace(buf, 0, 0, -1)
    -- set highlight on current line
    vim.api.nvim_buf_add_highlight(buf, 0, "PopupMenuSel", current - 1, 0, -1)
  end

  update_highlight()

  ---------------------------------------------------------
  -- MOVEMENT
  ---------------------------------------------------------


  local function move(delta)
    current = current + delta
    if current < 1 then current = #items end
    if current > #items then current = 1 end
    update_highlight()
    vim.api.nvim_win_set_cursor(win, { current, 0 })
  end

  ---------------------------------------------------------
  -- KEYMAPS

  ---------------------------------------------------------
  local opts = { buffer = buf, nowait = true, silent = true }


  vim.keymap.set("n", "j", function() move(1) end, opts)

  vim.keymap.set("n", "<Down>", function() move(1) end, opts)


  vim.keymap.set("n", "k", function() move(-1) end, opts)
  vim.keymap.set("n", "<Up>", function() move(-1) end, opts)

  vim.keymap.set("n", "<CR>", function()
    if on_select then on_select(current, items[current]) end
    vim.api.nvim_win_close(win, true)
  end, opts)

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, opts)

  -- block unwanted keys
  vim.keymap.set("n", "<any>", "<nop>", { buffer = buf })
end

M.config = {
  mode = "popup_menu",  -- or "show_list"
}


function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("TaskExecutor", function ()
    local data = read_json('tasks.json')
    if not data then
      return
    end
    local items = {}


    local callback = function(index , _)
      local cmd = data[index].command
      -- vim.notify('Selected ' .. index)
      -- vim.fn.jobstart(cmd, { detach = true })
      -- local output = vim.fn.system(cmd)
      -- print(output)
      vim.cmd("!" .. cmd)
    end

    -- show_list(items, function(index , _)
    if (M.config.mode == 'popup_menu') then
      for i, item in ipairs(data) do
        items[i] = item.name
      end
      popup_menu(items, callback)
    else
      for i, item in ipairs(data) do
        items[i] = i .. ". " .. item.name
      end
      show_list(items, callback)
    end
  end, {})
end

return M
