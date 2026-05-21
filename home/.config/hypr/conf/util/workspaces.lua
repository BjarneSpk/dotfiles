local M = {}

function M.get_active()
  return assert(hl.get_active_workspace(), "no active workspace")
end

return M
