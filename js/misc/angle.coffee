# @fileOverview A simple alarm clock (bell) that tells you when it's time to take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([], ->

	# This class represents an angle. 
	# Instances should be considered immutable.
	class Angle
		
		# Creates a new Angle. Should only be used by factory methods.
		# @param {number} rad
		constructor: (rad) ->
			@rad = rad

		# Creates a new Angle from radians
		# @param {number} rad The angle in radians
		# @returns {!Angle} A new angle object.
		# @static
		@initRadians: (rad) ->
			return new Angle(rad)

		# Creates a new Angle from degrees
		# @param {number} deg The angle in degrees
		# @returns {!Angle} A new angle object.
		# @static
		@initDegrees: (deg) ->
			return new Angle(deg * Math.PI/180)

		# Creates a new Angle from seconds.
		# @param {number} sec The angle in seconds.
		# @returns {!Angle} A new angle object.
		# @static
		@initSeconds: (sec) ->
			return new Angle(sec * Math.PI/30)
		
		# Creates a new Angle from minutes. Similar to initSeconds.
		# @param {number} min The angle in minutes.
		# @returns {!Angle} A new angle object.
		# @static
		@initMinutes: (min) ->
			return @initSeconds(min)

		# Creates a new Angle from hours.
		# @param {number} sec The angle in 12 hour format.
		# @returns {!Angle} A new angle object.
		# @static
		@initHours: (hour) ->
			return new Angle(hour * Math.PI/6)

		# Returns the value of the angle in radians.
		# @returns {number} The angle in radians.
		getRadians: () ->
			return @rad
		
		# Returns the value of the angle in degrees.
		# @returns {number} The angle in degrees.
		getDegrees: () ->
			return @rad / (Math.PI/180)

		# Returns a string representation of the angle. Particularly useful for setting css.
		# @returns {string} A string like '90deg'.
		toString: () ->
			return @getDegrees() + 'deg'

		# Adds the other angle to this one and creates a new angle object
		# @param {Angle} other The angle that should be added.
		# @returns {!Angle} The resulting angle
		add: (other) ->
			return new Angle(@rad + other.rad)

		# Compares this angle to another.
		# @param {Angle} other The angle for the comparison.
		# @returns {!number} Negative integer if this angle is less, zero if they are equal, or a
		# positive integer if this angle is more than the other
		compareTo: (other) ->
			return @rad - other.rad

	return Angle
)
