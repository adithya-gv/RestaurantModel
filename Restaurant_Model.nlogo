breed [cooks a-cook]
breed [servers a-server]
breed [customers a-customer]
globals [current capacity]
turtles-own [infected contagious]
customers-own [order-wait-time sitting-time]
extensions [gis]

;TODO - once patches are in, change the random movements to the coordinates of the door or
;counter and make them take a certain amount of ticks.

to setup
  clear-all
  reset-ticks
  ;load
  init
end

to go
  ;on repeat
  ;Starting setup - 2 people sitting uninfected, 1 person walks in who is infected
  ;No employees infected for now
  spawn-customers
  ;order
  ;sit
  ;infect
  ;load
  tick
end

to load
  ca
  let view gis:load-dataset "/Users/shahfamily/Documents/PANERA_TESTPLAN - Floor Plan - Level 1_polyline.shp"
  gis:set-world-envelope-ds gis:envelope-of view
  foreach gis:feature-list-of view [vector ->
    gis:set-drawing-color white
    gis:draw vector 1.0
  ]
end

to init
  ;Create 2 customers uninfected and sitting with sitting time 0
  create-customers 2 [
    set color green
    set sitting-time 0
    set order-wait-time -1
    set infected false
    set contagious false
    setxy random-xcor random-ycor ;Change to location of table
  ]
  create-cooks 2 [
    set color blue
    set infected false
    set contagious false
    setxy random-xcor random-ycor
  ]
  create-servers 2 [
    set color yellow
    set infected false
    set contagious false
    setxy random-xcor random-ycor
  ]
end

to spawn-customers
  ;TODO - probability that a customer will walk through the door
  ;At the start - the probability will be 100% since 1 person will enter
  ;Assume that every customer who enters will immeditaely go to order
  let num random 10
  let infect_p (random 11 <= infect_prob / 10 and infect_prob != 0)
  if (num = 9) [
   create-customers 1 [
      set sitting-time 0
      set order-wait-time 0
      set infected infect_p
      set contagious infect_p
      setxy random-xcor random-ycor ;Change to location of door
      ifelse (infected) [
        set color red
      ]
      [
        set color green
      ]
   ]
  ]
end


to exit
  ;TODO - customer who is currently sitting down may leave with probability
  ;Assume it takes 1 tick for someone to leave
  ;Make this probablity dependent on the time that the person has been sitting for
  foreach sort customers [the-customer ->
    if (random 10 = 9 and ([sitting-time] of the-customer) = 5) [
      ask the-customer [
        setxy random-xcor random-ycor ;Change to coordinates of door and make time based
        die
      ]
    ]
  ]
  if (random 10 = 9) [
    setxy random-xcor random-ycor
    die
  ]
end

to order
  ;TODO - customer orders, waits 5 ticks, then goes to seat
  foreach sort customers [the-customer ->
    if ([order-wait-time] of the-customer < 5) [
      ask the-customer [
        set order-wait-time (1 + [order-wait-time] of the-customer)
        setxy random-xcor random-ycor ;Change to coordinates of counter and make time based
      ]
    ]
  ]
end

to sit

end

to infect
  ; for now, just everything in a semicircle in the direction that the turtle is facing
  ; call breath infect or sneeze infect based on probability
  ;TODO
end
