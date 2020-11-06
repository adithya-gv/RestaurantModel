breed [cooks a-cook]
breed [servers a-server]
breed [customers a-customer]
globals [current capacity]
turtles-own [infected]
customers-own [order-wait-time sitting-time]

;TODO - once patches are in, change the random movements to the coordinates of the door or
;counter and make them take a certain amount of ticks.

to setup
  clear-all
  reset-ticks
  customer-init
end

to go
  ;on repeat
  ;Starting setup - 2 people sitting uninfected, 1 person walks in who is infected
  ;No employees infected for now
  spawn-customers
  order
  sit
  infect
  tick
end

to customer-init
  ;Create 2 customers uninfected and sitting with sitting time 0
  create-customers 2 [
    set color green
    set sitting-time 0
    set order-wait-time -1
    set infected false
    setxy random-xcor random-ycor ;Change to location of table
  ]
end

to spawn-customers
  ;TODO - probability that a customer will walk through the door
  ;At the start - the probability will be 100% since 1 person will enter
  ;Assume that every customer who enters will immeditaely go to order
  let num random 10
  let infect_p (random 10 = 9)
  if (num = 10) [
   create-customers 1 [
    set color green
    set sitting-time 0
    set order-wait-time 0
    set infected infect_p
    setxy random-xcor random-ycor ;Change to location of door
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
