# @fileOverview A minimal wrapper class for colors.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([], ->

	# This class represents a color. 
	# Instances should be considered immutable.
	class Color
		
		# Creates a new Color.
		# @param {number} r Red channel.
		# @param {number} g Green channel.
		# @param {number} b Blue channel.
		constructor: (r, g, b) ->
			@r = r
			@g = g
			@b = b

		# Creates a new Color from hex notation.
		# @param {string} hexString The color in hex notation as string.
		# @returns {Color} A new Color object.
		# @example white = Color.initHex('#ffffff');
		@initHex: (hexString) ->
			reg = /^#(\w{2})(\w{2})(\w{2})$/
			res = reg.exec(hexString)
			
			if res
				r = parseInt(res[1], 16)
				g = parseInt(res[2], 16)
				b = parseInt(res[3], 16)
			
			else
				reg = /^#(\w{1})(\w{1})(\w{1})$/
				res = reg.exec(hexString)
				
				if res
					r = parseInt(res[1] + res[1], 16)
					g = parseInt(res[2] + res[2], 16)
					b = parseInt(res[3] + res[3], 16)

			return new Color(r,g,b)
			
		# Creates a new Color from rgb notation
		# @param {string} hexString The color in rgb notation as string.
		# @returns {Color} A new Color object.
		# @example white = Color.initRGB('rgb(255,255,255)');
		@initRGB: (rgbString) ->
			reg = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/
			res = reg.exec(rgbString)
			
			if res
				r = parseInt(res[1])
				g = parseInt(res[2])
				b = parseInt(res[3])

			return new Color(r,g,b)
		
		# Returns the color as string.
		# @return {string} The color in hex notation.
		toHex: ->
			r = @r.toString(16)
			g = @g.toString(16)
			b = @b.toString(16)
			if r.length is 1 then r = '0' + r
			if g.length is 1 then g = '0' + g
			if b.length is 1 then b = '0' + b
			return "##{@r}#{@g}#{@b}"

		# Returns the color as string.
		# @return {string} The color in rgb notation.
		toRGB: ->
			return "rgb(#{@r},#{@g},#{@b})"
	
	return Color
)
