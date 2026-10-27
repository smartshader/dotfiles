-- Treat workspace directories such as `repos/` as first-class in nvim-tree even
-- though .gitignore lists them. Without this the builtin Git decorator paints
-- them with NvimTreeGitIgnored, which greys out the whole subtree.
--
-- Decorators apply additively in `renderer.decorators` order, so these must be
-- registered after "Git" to win.

local Decorator = require("nvim-tree.api").Decorator

local M = {}

-- Directory names whose subtrees are never greyed out.
M.dirs = { "repos" }

local function is_directory(node)
  return node.nodes ~= nil
end

local function in_workspace_dir(node)
  local path = node.absolute_path
  if not path then
    return false
  end
  for _, name in ipairs(M.dirs) do
    local escaped = vim.pesc(name)
    if path:match("/" .. escaped .. "$") or path:match("/" .. escaped .. "/") then
      return true
    end
  end
  return false
end

---Directories: override both icon and name so the folder glyph is not greyed.
local Directories = Decorator:extend()
M.Directories = Directories

function Directories:new()
  self.enabled = true
  self.highlight_range = "all"
  self.icon_placement = "none"
end

function Directories:highlight_group(node)
  if is_directory(node) and in_workspace_dir(node) then
    return "NvimTreeFolderName"
  end
end

---Files: override the name only, so devicon colours are preserved.
local Files = Decorator:extend()
M.Files = Files

function Files:new()
  self.enabled = true
  self.highlight_range = "name"
  self.icon_placement = "none"
end

function Files:highlight_group(node)
  if not is_directory(node) and in_workspace_dir(node) then
    return "NvimTreeNormal"
  end
end

---File icons: re-apply the devicon highlight on top of the greyed-out one.
local FileIcons = Decorator:extend()
M.FileIcons = FileIcons

function FileIcons:new()
  self.enabled = true
  self.highlight_range = "icon"
  self.icon_placement = "none"
end

function FileIcons:highlight_group(node)
  if is_directory(node) or not in_workspace_dir(node) then
    return nil
  end
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil
  end
  local _, hl = devicons.get_icon(node.name, node.extension, { default = true })
  return hl
end

return M
