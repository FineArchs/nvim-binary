local uv = vim.uv

local function readFileSync(path, skip, size)
	local fd = assert(uv.fs_open(path, "r", 438))
	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, math.min(stat.size - skip, size), skip))
	assert(uv.fs_close(fd))
	return data
end

local function readFile(path, skip, size, callback)
	uv.fs_open(path, "r", 438, function(err, fd)
		assert(not err, err)
		uv.fs_fstat(fd, function(err, stat)
			assert(not err, err)
			uv.fs_read(fd, math.min(stat.size - skip, size), skip, function(err, data)
				assert(not err, err)
				uv.fs_close(fd, function(err)
					assert(not err, err)
					return callback(data)
				end)
			end)
		end)
	end)
end
