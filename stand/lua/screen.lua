--
-- SPDX-License-Identifier: BSD-2-Clause-FreeBSD
--
-- Copyright (c) 2015 Pedro Souza <pedrosouza@freebsd.org>
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.
--
-- $FreeBSD$
--

local color = require("color")
local core = require("core")

local screen = {}

-- Module exports
function screen.clear()
	if core.isSerialBoot() then
		return
	end
	loader.printc(core.KEYSTR_CSI .. "H" .. core.KEYSTR_CSI .. "J")
end

function screen.setcursor(x, y)
	if core.isSerialBoot() then
		return
	end

	loader.printc(core.KEYSTR_CSI .. y .. ";" .. x .. "H")
end

function screen.movecursor(dx, dy)
	if core.isSerialBoot() then
		return
	end

	if dx < 0 then
		loader.printc(core.KEYSTR_CSI .. -dx .. "D")
	elseif dx > 0 then
		loader.printc(core.KEYSTR_CSI .. dx .. "C")
	end

	if dy < 0 then
		loader.printc(core.KEYSTR_CSI .. -dy .. "A")
	elseif dy > 0 then
		loader.printc(core.KEYSTR_CSI .. dy .. "B")
	end
end

function screen.setforeground(color_value)
	if color.disabled then
		return color_value
	end
	loader.printc(color.escapef(color_value))
end

function screen.setbackground(color_value)
	if color.disabled then
		return color_value
	end
	loader.printc(color.escapeb(color_value))
end

function screen.defcolor()
	loader.printc(color.default())
end

function screen.defcursor()
	if core.isSerialBoot() then
		return
	end
	loader.printc(core.KEYSTR_CSI .. "25;0H")
end

return screen
