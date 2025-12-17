extends Node

#region Music signals
@warning_ignore("unused_signal")
signal globalLevelStarted();
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
signal globalEnvironmentRiftAreaClosed();

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
#endregion Player signals

#region UI signals
@warning_ignore("unused_signal")
signal globalUiElementSelected();

@warning_ignore("unused_signal")
signal globalUiElementMouseEntered();
#endregion UI signals
