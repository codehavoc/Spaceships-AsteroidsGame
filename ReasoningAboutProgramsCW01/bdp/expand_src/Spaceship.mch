/***************************************************
 * 6SENG001W Reasoning About Programs Coursework 01
 * w1714906 / 2018158
 * Spaceship
 * Author: Udara Nayana
 * Creation date: 19-Nov-21
 ***************************************************/
MACHINE
    Spaceship
SEES
    Space
SETS
    DIRECTIONS = { Up , Down , Foward , Reverse } ;
    MOVEMENTLOGS = { Movement_Successful , Movement_Failed , Movement_Failed_Due_To_Being_Out_Of_Bounds ,
                    Movement_Failed_Due_To_Asteroid_Collision , Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power ,
                    Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over , Successfully_Reached_Starbase , Warp_Drive_Successful ,
                    Unable_To_Warp_Drive_Due_To_Insufficient_Power , Warp_Drive_Failed_Due_To_Asteroid_Collision ,
                    Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ,
                    Warp_Drive_Failed_Due_To_Being_Out_Of_Bounds , Warp_Drive_Failed_Due_To_Still_In_Homebase ,
                    Game_Over_Start_New_Game , Starting_New_Game } ;
    GAMESTATUS = { Game_Won , Game_Lost , Game_Not_Over } ;
    SPACESHIPPOS = { Spaceship_Docked_In_Starbase , Spaceship_Not_Docked_In_Starbase }
CONCRETE_CONSTANTS
    NormalMoveEnergyCost ,
    WarpDriveEnergyCost ,
    AsteroidCollisionEnergyCost
PROPERTIES
    NormalMoveEnergyCost : NAT1 &
    NormalMoveEnergyCost = 5 &
    WarpDriveEnergyCost : NAT1 &
    WarpDriveEnergyCost = 20 &
    AsteroidCollisionEnergyCost : NAT1 &
    AsteroidCollisionEnergyCost = 10
ABSTRACT_VARIABLES
    spaceshipEnergyReserve ,
    shipXPos ,
    shipYPos ,
    gameStatus ,
    collisionCount ,
    missionRoute ,
    energyRefillOptions
INVARIANT
    spaceshipEnergyReserve : NAT &
    shipXPos : SpaceXAxisRange &
    shipYPos : SpaceYAxisRange &
    gameStatus <: GAMESTATUS &
    collisionCount : NAT &
    missionRoute : seq ( SpaceArea ) &
    energyRefillOptions <: NAT
INITIALISATION
    spaceshipEnergyReserve := 200 ||
    shipXPos := 1 ||
    shipYPos := 1 ||
    gameStatus := { Game_Not_Over } ||
    collisionCount := 0 ||
    missionRoute := [ ( 1 |-> 1 ) ] ||
    energyRefillOptions := { 1 , 5 , 10 , 20 , 50 , 100 , 150 , 200 }
OPERATIONS
    /* Spaceship Moving Upward */
    logMessage <-- MoveUp =
    PRE logMessage : MOVEMENTLOGS & Game_Not_Over : gameStatus
    THEN
        IF ( shipXPos |-> succ ( shipYPos ) ) : SpaceArea
        THEN
            IF ( shipXPos |-> succ ( shipYPos ) ) /: Asteroids
            THEN
                IF  not ( ( shipXPos |-> succ ( shipYPos ) ) : Starbase )
                THEN
                    IF ( spaceshipEnergyReserve - NormalMoveEnergyCost ) >= NormalMoveEnergyCost
                    THEN
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipYPos := succ ( shipYPos ) ||
                        missionRoute := missionRoute ^ [ ( shipXPos |-> succ ( shipYPos ) ) ] ||
                        logMessage := Movement_Successful ||
                        gameStatus := { Game_Not_Over }
                    ELSE
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipYPos := succ ( shipYPos ) ||
                        missionRoute := missionRoute ^ [ ( shipXPos |-> succ ( shipYPos ) ) ] ||
                        logMessage := Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over ||
                        gameStatus := { Game_Lost }
                    END
                ELSE
                    spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                    shipYPos := succ ( shipYPos ) ||
                    missionRoute := missionRoute ^ [ ( shipXPos |-> succ ( shipYPos ) ) ] ||
                    logMessage := Successfully_Reached_Starbase ||
                    gameStatus := { Game_Won }
                END
            ELSIF ( spaceshipEnergyReserve - AsteroidCollisionEnergyCost ) >= NormalMoveEnergyCost
                THEN
                    spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                    collisionCount := succ ( collisionCount ) ||
                    logMessage := Movement_Failed_Due_To_Asteroid_Collision ||
                    gameStatus := { Game_Not_Over }
            ELSE
                spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                collisionCount := succ ( collisionCount ) ||
                logMessage := Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ||
                gameStatus := { Game_Lost }
            END
        ELSE
            logMessage := Movement_Failed_Due_To_Being_Out_Of_Bounds
        END
    END ;


    /* Spaceship Moving Downward */
    logMessage <-- MoveDown =
    PRE logMessage : MOVEMENTLOGS & Game_Not_Over : gameStatus
    THEN
        IF ( shipXPos |-> pred ( shipYPos ) ) : SpaceArea
        THEN
            IF ( shipXPos |-> pred ( shipYPos ) ) /: Asteroids
            THEN
                IF  not ( ( shipXPos |-> pred ( shipYPos ) ) : Starbase )
                THEN
                    IF ( spaceshipEnergyReserve - NormalMoveEnergyCost ) >= NormalMoveEnergyCost
                    THEN
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipYPos := pred ( shipYPos ) ||
                        missionRoute := missionRoute ^ [ ( shipXPos |-> pred ( shipYPos ) ) ] ||
                        logMessage := Movement_Successful ||
                        gameStatus := { Game_Not_Over }
                    ELSE
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipYPos := pred ( shipYPos ) ||
                        missionRoute := missionRoute ^ [ ( shipXPos |-> pred ( shipYPos ) ) ] ||
                        logMessage := Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over ||
                        gameStatus := { Game_Lost }
                    END
                ELSE
                    spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                    shipYPos := pred ( shipYPos ) ||
                    missionRoute := missionRoute ^ [ ( shipXPos |-> pred ( shipYPos ) ) ] ||
                    logMessage := Successfully_Reached_Starbase ||
                    gameStatus := { Game_Won }
                END
            ELSIF ( spaceshipEnergyReserve - AsteroidCollisionEnergyCost ) >= NormalMoveEnergyCost
                THEN
                    spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                    collisionCount := succ ( collisionCount ) ||
                    logMessage := Movement_Failed_Due_To_Asteroid_Collision ||
                    gameStatus := { Game_Not_Over }
            ELSE
                spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                collisionCount := succ ( collisionCount ) ||
                logMessage := Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ||
                gameStatus := { Game_Lost }
            END
        ELSE
            logMessage := Movement_Failed_Due_To_Being_Out_Of_Bounds
        END
    END ;


    /* Spaceship Moving Forward */
    logMessage <-- MoveForward =
    PRE logMessage : MOVEMENTLOGS & Game_Not_Over : gameStatus
    THEN
        IF ( succ ( shipXPos ) |-> shipYPos ) : SpaceArea
        THEN
            IF ( succ ( shipXPos ) |-> shipYPos ) /: Asteroids
            THEN
                IF  not ( ( succ ( shipXPos ) |-> shipYPos ) : Starbase )
                THEN
                    IF ( spaceshipEnergyReserve - NormalMoveEnergyCost ) >= NormalMoveEnergyCost
                    THEN
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipXPos := succ ( shipXPos ) ||
                        missionRoute := missionRoute ^ [ ( succ ( shipXPos ) |-> shipYPos ) ] ||
                        logMessage := Movement_Successful ||
                        gameStatus := { Game_Not_Over }
                    ELSE
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipXPos := succ ( shipXPos ) ||
                        missionRoute := missionRoute ^ [ ( succ ( shipXPos ) |-> shipYPos ) ] ||
                        logMessage := Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over ||
                        gameStatus := { Game_Lost }
                    END
                ELSE
                    spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                    shipXPos := succ ( shipXPos ) ||
                    missionRoute := missionRoute ^ [ ( succ ( shipXPos ) |-> shipYPos ) ] ||
                    logMessage := Successfully_Reached_Starbase ||
                    gameStatus := { Game_Won }
                END
            ELSIF ( spaceshipEnergyReserve - AsteroidCollisionEnergyCost ) >= NormalMoveEnergyCost
                THEN
                    spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                    collisionCount := succ ( collisionCount ) ||
                    logMessage := Movement_Failed_Due_To_Asteroid_Collision ||
                    gameStatus := { Game_Not_Over }
            ELSE
                spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                collisionCount := succ ( collisionCount ) ||
                logMessage := Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ||
                gameStatus := { Game_Lost }
            END
        ELSE
            logMessage := Movement_Failed_Due_To_Being_Out_Of_Bounds
        END
    END ;


    /* Spaceship Moving Backward */
    logMessage <-- MoveBackward =
    PRE logMessage : MOVEMENTLOGS & Game_Not_Over : gameStatus
    THEN
        IF ( pred ( shipXPos ) |-> shipYPos ) : SpaceArea
        THEN
            IF ( pred ( shipXPos ) |-> shipYPos ) /: Asteroids
            THEN
                IF  not ( ( pred ( shipXPos ) |-> shipYPos ) : Starbase )
                THEN
                    IF ( spaceshipEnergyReserve - NormalMoveEnergyCost ) >= NormalMoveEnergyCost
                    THEN
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipXPos := pred ( shipXPos ) ||
                        missionRoute := missionRoute ^ [ ( pred ( shipXPos ) |-> shipYPos ) ] ||
                        logMessage := Movement_Successful ||
                        gameStatus := { Game_Not_Over }
                    ELSE
                        spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                        shipXPos := pred ( shipXPos ) ||
                        missionRoute := missionRoute ^ [ ( pred ( shipXPos ) |-> shipYPos ) ] ||
                        logMessage := Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over ||
                        gameStatus := { Game_Lost }
                    END
                ELSE
                    spaceshipEnergyReserve := spaceshipEnergyReserve - NormalMoveEnergyCost ||
                    shipXPos := pred ( shipXPos ) ||
                    missionRoute := missionRoute ^ [ ( pred ( shipXPos ) |-> shipYPos ) ] ||
                    logMessage := Successfully_Reached_Starbase ||
                    gameStatus := { Game_Won }
                END
            ELSIF ( spaceshipEnergyReserve - AsteroidCollisionEnergyCost ) >= NormalMoveEnergyCost
                THEN
                    spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                    collisionCount := succ ( collisionCount ) ||
                    logMessage := Movement_Failed_Due_To_Asteroid_Collision ||
                    gameStatus := { Game_Not_Over }
            ELSE
                spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                collisionCount := succ ( collisionCount ) ||
                logMessage := Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ||
                gameStatus := { Game_Lost }
            END
        ELSE
            logMessage := Movement_Failed_Due_To_Being_Out_Of_Bounds
        END
    END ;


    /* Spaceship Warp Driving */
    logMessage <-- EngageWarpDrive ( posX , posY ) =
    PRE logMessage : MOVEMENTLOGS & posX : SpaceXAxisRange & posY : SpaceYAxisRange & Game_Not_Over : gameStatus
    THEN
        IF  spaceshipEnergyReserve >= WarpDriveEnergyCost
        THEN
            /* Added restriction of directly warping to destination from Home or warping back to Home from any other region */
            IF ( posX |-> posY ) : SpaceArea & ( shipXPos |-> shipYPos ) /: Homebase & ( posX |-> posY ) /: Homebase
            THEN
                IF ( posX |-> posY ) /: Asteroids
                THEN
                    IF  not ( ( posX |-> posY ) : Starbase )
                    THEN
                        IF ( spaceshipEnergyReserve - WarpDriveEnergyCost ) >= NormalMoveEnergyCost
                        THEN
                            spaceshipEnergyReserve := spaceshipEnergyReserve - WarpDriveEnergyCost ||
                            shipXPos := posX ||
                            shipYPos := posY ||
                            missionRoute := missionRoute ^ [ ( posX |-> posY ) ] ||
                            logMessage := Warp_Drive_Successful ||
                            gameStatus := { Game_Not_Over }
                        ELSE
                            spaceshipEnergyReserve := spaceshipEnergyReserve - WarpDriveEnergyCost ||
                            shipXPos := posX ||
                            shipYPos := posY ||
                            missionRoute := missionRoute ^ [ ( posX |-> posY ) ] ||
                            logMessage := Failed_To_Reach_Starbase_Due_To_Insufficient_Power_Game_Over ||
                            gameStatus := { Game_Lost }
                        END
                    ELSE
                        spaceshipEnergyReserve := spaceshipEnergyReserve - WarpDriveEnergyCost ||
                        shipXPos := posX ||
                        shipYPos := posY ||
                        missionRoute := missionRoute ^ [ ( posX |-> posY ) ] ||
                        logMessage := Successfully_Reached_Starbase ||
                        gameStatus := { Game_Won }
                    END
                ELSIF   ( spaceshipEnergyReserve - AsteroidCollisionEnergyCost ) >= NormalMoveEnergyCost
                    THEN
                        spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                        collisionCount := succ ( collisionCount ) ||
                        logMessage := Warp_Drive_Failed_Due_To_Asteroid_Collision ||
                        gameStatus := { Game_Not_Over }
                ELSE
                    spaceshipEnergyReserve := spaceshipEnergyReserve - AsteroidCollisionEnergyCost ||
                    collisionCount := succ ( collisionCount ) ||
                    logMessage := Movement_Failed_Due_To_Asteroid_Collision_And_Insufficient_Power_Game_Over ||
                    gameStatus := { Game_Lost }
                END
            ELSE
                IF ( shipXPos |-> shipYPos ) : Homebase
                THEN
                    logMessage := Warp_Drive_Failed_Due_To_Still_In_Homebase
                ELSE
                    logMessage := Warp_Drive_Failed_Due_To_Being_Out_Of_Bounds
                END
            END
        ELSE
            logMessage := Unable_To_Warp_Drive_Due_To_Insufficient_Power
        END
    END ;


    /* Start New Game */
    logMessage <-- NewGame ( power ) =
    PRE logMessage : MOVEMENTLOGS & power : energyRefillOptions
    THEN
        shipXPos := 1 ||
        shipYPos := 1 ||
        spaceshipEnergyReserve := power ||
        collisionCount := 0 ||
        missionRoute := [ ( 1 |-> 1 ) ] ||
        gameStatus := { Game_Not_Over } ||
        logMessage := Starting_New_Game
    END ;


    /* Spaceship Mission Status */
    currentLoc , powerReserve , Collisions <-- MissionStatus =
    BEGIN
        currentLoc , powerReserve , Collisions := ( shipXPos |-> shipYPos ) , spaceshipEnergyReserve , collisionCount
    END ;


    /* Spaceship Mission Route */
    route <-- SpaceshipRoute =
    BEGIN
        route := missionRoute
    END ;


    /* Spaceship Docked Status */
    logMessage <-- SpaceshipDockedStatus =
    PRE logMessage : SPACESHIPPOS
    THEN
        IF ( shipXPos |-> shipYPos ) : Starbase
        THEN
            logMessage := Spaceship_Docked_In_Starbase
        ELSE
            logMessage := Spaceship_Not_Docked_In_Starbase
        END
    END ;


    /* Game Status */
    game <-- GameCurrentStatus =
    BEGIN
        game := gameStatus
    END

END
