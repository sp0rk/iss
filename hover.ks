// This file is distributed under the terms of the MIT license, (c) the KSLib team
clearscreen.
SAS on.
set seekAlt to 50.

print "A simple test of libPID.".
print "Does a hover script at " + seekAlt + "m AGL.".
print " ".
print "  Try flying around with WASD while it hovers.".
print "  (steering is unlocked. under your control.".
print " ".
print "  Keys:".
print "     Action Group 1 : -10 hover altitude".
print "     Action Group 2 :  -1 hover altitude".
print "     Action Group 3 :  +1 hover altitude".
print "     Action Group 4 : +10 hover altitude".
print "     LANDING LEGS   : Deploy to exit script".
print " ".
print " Seek ALT:RADAR = ".
print "  Cur ALT:RADAR = ".
print " ".
print "       Throttle = ".

// load the functions I'm using:
run "lib_PID".

on ag1 { set seekAlt to seekAlt -10. preserve. }.
on ag2 { set seekAlt to seekAlt - 1. preserve. }.
on ag3 { set seekAlt to seekAlt + 1. preserve. }.
on ag4 { set seekAlt to seekAlt +10. preserve. }.

set ship:control:pilotmainthrottle to 0.

// hit "stage" until there's an active engine:
until ship:availablethrust > 0 {
  wait 0.5.
  stage.
}.

// Call to update the display of numbers:
function display_block {
  parameter startCol, startRow. // define where the block of text should be positioned

  print round(seekAlt,2) + "m    " at (startCol,startRow).
  print round(alt:radar,2) + "m    " at (startCol,startRow+1).
  print round(myth,3) + "      " at (startCol,startRow+3).
}.


// thOffset is how far off from midThrottle to be.
// It's the value I'll be letting the PID controller
// adjust for me.
set myTh to 0.

lock throttle to myTh.

SET MYSTEER TO HEADING(0,90).
LOCK STEERING TO MYSTEER.



set kp to 0.5.
set ki to 0.
set kd to 0.

set hoverPID to PIDLOOP( kp, ki, kd, 0, 1 ). // Kp, Ki, Kd, min, max control  range vals.
set hoverPID:SETPOINT to 50.

set height_log to list().
set velocity_log to list().
set thrust_log to list().
set time_log to list().
set target_log to list().
set start_time to Time:SECONDS.
// Call to log data
function log_data {
  time_log:add(Time:SECONDS - start_time).
	height_log:add(alt:radar).
	velocity_log:add(VERTICALSPEED).
	thrust_log:add(myTh*AVAILABLETHRUST).
  target_log:add(hoverPID:SETPOINT).
}.

set t to Time:SECONDS - start_time.
until t>=90 {
  set t to Time:SECONDS - start_time. 
  if t < 20 { set hoverPID:SETPOINT to 50. }
  else if t >= 20 AND t < 40 { set hoverPID:SETPOINT to 100. }
  else if t >= 40 AND t < 50 { set hoverPID:SETPOINT to 110. }
  else if t >= 50 AND t < 90 { set hoverPID:SETPOINT to 50. }

  set myTh to hoverPID:UPDATE(Time:SECONDS, alt:radar ).
  display_block(18,13).
  log_data().
  wait 0.001.
}.

// Call to update the display of numbers:
function display_block {
  parameter startCol, startRow. // define where the block of text should be positioned

  print round(hoverPID:SETPOINT,2) + "m    " at (startCol,startRow).
  print round(alt:radar,2) + "m    " at (startCol,startRow+1).
  print round(myth,3) + "      " at (startCol,startRow+3).
}.

set ship:control:pilotmainthrottle to throttle.
print "------------------------------".
print "Releasing control back to you.".
print "------------------------------".


set logger to list().
logger:add(time_log).
logger:add(height_log).
logger:add(thrust_log).
logger:add(velocity_log).
logger:add(target_log).
writejson(logger, "logx" + kp + "x" + ki + "x" + kd + "x.json").

print "Log saved.".