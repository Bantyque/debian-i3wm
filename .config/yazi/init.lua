-- ~/.config/yazi/init.lua
-- Custom line mode: size + modification date in every row.
-- Extra status/header segments: owner:group, size, mtime, symlink target, user@host.

local function read_pywal_colors()
	local paths = {
		os.getenv("WAL_COLORS"),
		(os.getenv("HOME") or "") .. "/.cache/wal/colors",
		(os.getenv("HOME") or "") .. "/.cache/wal/colors.sh",
	}
	local colors = {}
	for _, path in ipairs(paths) do
		if path and path ~= "" then
			local f = io.open(path, "r")
			if f then
				local text = f:read("*a") or ""
				f:close()
				for hex in text:gmatch("#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]") do
					table.insert(colors, hex:lower())
					if #colors >= 16 then break end
				end
				if #colors >= 8 then break end
			end
		end
	end
	local fallback = {
		"#1d2021", "#cc241d", "#98971a", "#d79921",
		"#458588", "#b16286", "#689d6a", "#a89984",
		"#928374", "#fb4934", "#b8bb26", "#fabd2f",
		"#83a598", "#d3869b", "#8ec07c", "#ebdbb2",
	}
	if #colors < 8 then colors = fallback end
	while #colors < 16 do table.insert(colors, colors[#colors]) end
	return colors
end

local C = read_pywal_colors()

local function safe_mtime(raw)
	local time = tonumber(tostring(raw or ""):sub(1, 10)) or 0
	if time == 0 then
		return "-"
	elseif os.date("%Y", time) == os.date("%Y") then
		return os.date("%d.%m %H:%M", time)
	else
		return os.date("%d.%m.%Y", time)
	end
end

local function readable_size(file)
	if not file then return "-" end
	local ok, size = pcall(function() return file:size() end)
	if not ok or not size then
		size = file.cha and file.cha.len
	end
	return size and ya.readable_size(size) or "-"
end

function Linemode:size_and_mtime()
	local time = safe_mtime(self._file and self._file.cha and self._file.cha.mtime)
	local size = readable_size(self._file)
	return string.format("%s  %s", size, time)
end

-- Symlink target on the left side of the status bar.
if Status and Status.children_add then
	Status:children_add(function()
		local h = cx.active.current.hovered
		if h and h.link_to then
			return ui.Line {
				ui.Span(" -> "):fg(C[9]),
				ui.Span(tostring(h.link_to)):fg(C[7]),
			}
		end
		return ""
	end, 3300, Status.LEFT)

	-- Size + modification time of the hovered file on the right side.
	Status:children_add(function()
		local h = cx.active.current.hovered
		if not h then return "" end
		return ui.Line {
			ui.Span(" 󰋊 "):fg(C[5]),
			ui.Span(readable_size(h)):fg(C[15]),
			ui.Span(" 󰥔 "):fg(C[4]),
			ui.Span(safe_mtime(h.cha and h.cha.mtime)):fg(C[14]),
			ui.Span(" "),
		}
	end, 600, Status.RIGHT)

	-- Owner:group on Unix.
	Status:children_add(function()
		local h = cx.active.current.hovered
		if not h or not h.cha or ya.target_family() ~= "unix" then return "" end
		local user = ya.user_name(h.cha.uid) or tostring(h.cha.uid or "?")
		local group = ya.group_name(h.cha.gid) or tostring(h.cha.gid or "?")
		return ui.Line {
			ui.Span("  "):fg(C[6]),
			ui.Span(user):fg(C[11]),
			ui.Span(":"):fg(C[9]),
			ui.Span(group):fg(C[11]),
			ui.Span(" "),
		}
	end, 700, Status.RIGHT)
end

-- Small user@host prefix in the header.
if Header and Header.children_add then
	Header:children_add(function()
		if ya.target_family() ~= "unix" then return "" end
		return ui.Line {
			ui.Span(" "):fg(C[5]),
			ui.Span(ya.user_name() or "user"):fg(C[5]),
			ui.Span("@"):fg(C[9]),
			ui.Span(ya.host_name() or "host"):fg(C[7]),
			ui.Span(" "),
		}
	end, 500, Header.LEFT)
end

-- Current filesystem usage in the status bar.
-- Shows used/free space for the filesystem that contains the current Yazi directory.
-- Cached for a few seconds to avoid running `df` on every redraw.
local function sh_quote(s)
	return "'" .. tostring(s or "."):gsub("'", "'\\''") .. "'"
end

local function url_to_path(u)
	local s = tostring(u or ".")
	s = s:gsub("^file://", "")
	s = s:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)
	if s == "" then s = "." end
	return s
end

local disk_cache = { path = nil, at = 0, line = "" }

local function disk_usage_line()
	local cwd = cx and cx.active and cx.active.current and cx.active.current.cwd
	local path = url_to_path(cwd)
	local now = os.time()
	if disk_cache.path == path and now - disk_cache.at < 10 then
		return disk_cache.line
	end

	local cmd = "df -hP " .. sh_quote(path) .. " 2>/dev/null | awk 'NR==2 {print $3\" used / \"$4\" free \"$5}'"
	local f = io.popen(cmd)
	local out = f and f:read("*l") or nil
	if f then f:close() end

	disk_cache.path = path
	disk_cache.at = now
	disk_cache.line = out and out ~= "" and out or ""
	return disk_cache.line
end

if Status and Status.children_add then
	Status:children_add(function()
		local line = disk_usage_line()
		if line == "" then return "" end
		return ui.Line {
			ui.Span(" 󰋊 "):fg(C[4]),
			ui.Span(line):fg(C[12]),
			ui.Span(" "),
		}
	end, 850, Status.RIGHT)
end

-- Optional: Recycle Bin plugin. Safe if the plugin is not installed.
-- Install it with: ya pkg add uhs-robert/recycle-bin
local ok_recycle, recycle = pcall(require, "recycle-bin")
if ok_recycle and recycle and recycle.setup then
	recycle:setup()
end

