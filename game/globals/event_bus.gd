extends Node

#region Music signals
@warning_ignore("unused_signal")
signal globalLevel1Started();
@warning_ignore("unused_signal")
signal globalLevelNStarted();
@warning_ignore("unused_signal")
signal globalLevelSuccess();
@warning_ignore("unused_signal")
signal globalLevelFailed();
@warning_ignore("unused_signal")
signal globalIntermissionEntered();
@warning_ignore("unused_signal")
signal globalTitleEntered();
@warning_ignore("unused_signal")
signal globalCreditsEntered();
#endregion Music signals

#region Enemy signals
@warning_ignore("unused_signal")
signal globalEnemyDestroyed();

@warning_ignore("unused_signal")
signal globalEnemyHurt();

@warning_ignore("unused_signal")
signal globalEnemyHoverEnd();

@warning_ignore("unused_signal")
signal globalEnemyHoverStart();
#endregion Enemy signals

#region Environment signals
@warning_ignore("unused_signal")
signal globalEnvironmentRiftAreaClosed(vent: VentHole);

@warning_ignore("unused_signal")
signal globalEnvironmentRiftAreaEntered();

@warning_ignore("unused_signal")
signal globalEnvironmentRiftAreaLeaveEarly();

@warning_ignore("unused_signal")
signal globalEnvironmentRiftBigEruption();

@warning_ignore("unused_signal")
signal globalEnvironmentRiftBigReadyToLaunch();
#endregion Environment signals

#region Player signals
@warning_ignore("unused_signal")
signal globalPlayerHurt();

@warning_ignore("unused_signal")
signal globalPlayerPowerUpGained();

@warning_ignore("unused_signal")
signal globalPlayerWalkEnd();

@warning_ignore("unused_signal")
signal globalPlayerWalkStart();

@warning_ignore("unused_signal")
signal globalPlayerPowerup();

@warning_ignore("unused_signal")
signal globalPlayerShoot();
#endregion Player signals

#region UI signals
@warning_ignore("unused_signal")
signal globalUiElementSelected();

@warning_ignore("unused_signal")
signal globalUiElementMouseEntered();
#endregion UI signals
