/***************************************************
 * 6SENG001W Reasoning About Programs Coursework 01
 * w1714906 / 2018158
 * Space
 * Author: Udara Nayana
 * Creation date: 19-Nov-21
 ***************************************************/
MACHINE
    Space
CONCRETE_CONSTANTS
    SpaceXAxisRange ,
    SpaceYAxisRange ,
    SpaceArea ,
    Asteroids ,
    Homebase ,
    Starbase
PROPERTIES
    SpaceXAxisRange <: NAT1 &
    SpaceXAxisRange = 1 .. 12 &
    SpaceYAxisRange <: NAT1 &
    SpaceYAxisRange = 1 .. 7 &
    SpaceArea = ( SpaceXAxisRange * SpaceYAxisRange ) &
    Asteroids <: SpaceArea &
    Asteroids = { ( 3 |-> 2 ) , ( 3 |-> 5 ) , ( 5 |-> 4 ) , ( 6 |-> 7 ) , ( 7 |-> 1 ) ,
                 ( 7 |-> 5 ) , ( 7 |-> 7 ) , ( 8 |-> 3 ) , ( 10 |-> 6 ) , ( 11 |-> 2 ) , ( 12 |-> 5 ) } &
    Starbase <: SpaceArea &
    Starbase = { ( 6 |-> 4 ) } &
    Homebase <: SpaceArea &
    Homebase = { ( 1 |-> 1 ) }
END
